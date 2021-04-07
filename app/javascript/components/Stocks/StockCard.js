import React from 'react'
import { BrowserRouter as Router, Link } from 'react-router-dom'

const Stock = (props) => {
  return(
    <div className="card">
      <div className="stock-symbol">
        <Link to={"/stocks/"+ props.attributes.symbol}>{props.attributes.symbol}</Link>
      </div>
      <div className="stock-exchange">{props.attributes.exchangeName}</div>
      <div className="stock-price">{props.attributes.chartPreviousClose}</div>
    </div>
  )
}

export default Stock