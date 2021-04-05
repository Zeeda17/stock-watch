import React from 'react'
import {Route, Switch} from 'react-router-dom'
import Stocks from './Stocks/Stocks'
import Stock from './Stock/Stock'

const App = () => {
  return (
    <Switch>
      <Route exact path="/stocks" component={Stocks}/>
      <Route exact path="/stocks/:exchangeName/:symbol" component={Stock}/>
    </Switch>
  )
}

export default App