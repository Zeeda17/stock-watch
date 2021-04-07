import React, {useState, useEffect, Fragment} from 'react'
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

  const list = stocks.map( item => {
    return (<li key={item.attributes.name}>{item.attributes.name}</li>)
  })

  return(
    <div className="home">
      <div className="header">
        <h1>Some examples...</h1>
        <div className="subheader">There are so many more.</div>
      </div>
      <div className="grid">
        <ul>{list}</ul>
      </div>
    </div>
  )
}

export default Stocks