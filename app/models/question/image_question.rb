# encoding: utf-8
require_relative "text_question"
require "paperclip"
require "active_support/core_ext/numeric/bytes"
require "active_support/inflector/transliterate"
require "uri"
require "open-uri"

class ImageQuestion < TextQuestion
  data_accessor *Paperclip::Schema::COLUMNS.keys.map { |name| :"image_#{name}" }, :image_size

  serialize :image_size, Hash

  include Paperclip::Glue
  has_attached_file :image, styles: {resized: "x250>"}

  assign_image = instance_method(:image=)
  define_method(:image=) do |file|
    assign_image.bind(self).call(file)
    assign_image_sizes
  end

  attr_reader :image_url, :image_file
  def image_url=(url)
    if url.present?
      @image_url = url
      begin
        validate_image_url!
        self.image = URI.parse(url)
      rescue SocketError, URI::InvalidURIError, InvalidImageFormat => exception
        if exception.is_a?(InvalidImageFormat)
          errors.add(:image_url, "URL ne pokazuje na sliku (URL mora završavati sa \".jpg\", \".png\" i sl, a ne npr. sa \".html\")")
        end
      end
    end
  end
  def image_file=(file)
    if file.present?
      @image_file = file
      self.image = UploadedFile.new(file)
    end
  end

  class UploadedFile
    include ActiveSupport::Inflector

    def initialize(file)
      @file = file
    end

    def original_filename
      transliterate(@file.original_filename)
    end

    def method_missing(*args, &block)
      @file.send(*args, &block)
    end
  end

  def image_width(style = :original)  image_size[style][:width] end
  def image_height(style = :original) image_size[style][:height] end

  validate :validate_image_url
  validate :validate_image_size
  validates_attachment_presence :image

  def dup
    super.tap do |question|
      question.instance_variable_set("@image_url", self.image.url)
    end
  end

  def duplicate
    dup.tap do |question|
      question.image_url = self.image.url
      question.save
    end
  end

  private

  def assign_image_sizes
    self.image_size = image.instance_variable_get("@queued_for_write").inject({}) do |hash, (style, file)|
      geometry = Paperclip::Geometry.from_file(file)
      hash.update(style => {width: geometry.width.to_i, height: geometry.height.to_i})
    end
  end

  def validate_image_url
    if image_url.present? and not image.present?
      errors[:image] << "Nije validna URL adresa."
    end
  end

  def validate_image_size
    if image.present?
      errors[:image] << "Slika ne smije biti veća od 1 MB." if image.size > 1.megabyte
    end
  end

  def validate_image_url!
    url = URI.parse(image_url)
    url.query = nil
    if not IMAGE_EXTENSIONS.include?(File.extname(url.to_s))
      raise InvalidImageFormat
    end
  end

  IMAGE_EXTENSIONS = [
    %w[.jpg .jpeg .jpe .jif .jfif .jfi],
    %w[.gif],
    %w[.png],
    %w[.svg .svgz],
    %w[.tiff .tif],
    %w[.ico],
  ].flatten

  class InvalidImageFormat < RuntimeError; end
end
