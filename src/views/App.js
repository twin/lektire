import React, { PropTypes } from 'react';
import style from '../styles/App.scss';

export const App = props => (
  <div className={style.container}>
    {props.children}
  </div>
);

App.propTypes = {
  children: PropTypes.node,
};

export default App;
