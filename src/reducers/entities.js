import merge from 'lodash/merge';

const initialState = {
  quizzes: {},
};

export default function reducer(state = initialState, action) {
  if (action.payload && action.payload.entities) {
    return merge({}, state, action.payload.entities);
  }

  return state;
}
