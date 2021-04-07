import React, {useState, useEffect, Fragment} from 'react'
import StockCard from './StockCard'
import axios from 'axios'

const Stocks = () => {
  const [stocks, setStocks] = useState([])

useEffect(() => {
  //get all stocks from api
  //update stocks in state

  axios.get('api/v1/stocks.json')
  .then( resp => {
   setStocks(resp.data.data) 
  })
  .catch( resp => console.log(resp))
}, [stocks.length]) // 2nd arg says only re-run effect if this changes

  const grid = stocks.map( item => {
    return (
      <StockCard 
        key={item.attributes.symbol}
        attributes={item.attributes}
      />
    )
  })

  return(
    <div className="home">
      <div className="header">
        <h1>Some examples...</h1>
        <div className="subheader">There are so many more.</div>
      </div>
      <div className="grid">
        <ul>{grid}</ul>
      </div>
    </div>
  )
}

export default Stocks