import React, {useState, useEffect, Fragment} from 'react'
import axios from 'axios'

const Stock = (props) => {
  const [stock, setStock] = useState()
  const [stockPrice, setStockPrice] = useState()
  

  useEffect(() => {
    const symbol = props.match.params.symbol
    const url = '/api/v1/stocks/' + symbol
    
    //resp.data.data
    axios.get(url)
    .then(resp => setStock(resp.data))
    .catch(resp => console.log(resp))
  }, [])

  return (
    <div className="wrapper">
      <div className="column">
        <div className="header"></div>
        <div className="prices"></div>
      </div>
      <div className="column">
        <div className="toggle-watch">TOGGLE FOR WATCHING STOCK HERE</div>
      </div>
    </div>
  )
}

export default Stock