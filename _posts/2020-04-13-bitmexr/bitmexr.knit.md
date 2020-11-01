---
title: "bitmexr: An R client for BitMEX cryptocurrency exchange."
description: |
  How bitmexr came to be.
author:
  - name: Harry Fisher
    url: https://hfshr.netlify.com/
date: 04-13-2020
output:
  distill::distill_article:
    self_contained: false
categories:
  - Bitcoin
  - R
bibliography: r-references.bib  
preview: images/price.gif
---



While writing my previous post, I was surprised to find that there was no R related package for the cryptocurrency exchange BitMEX. 
While cryptocurrency itself is a somewhat niche area, BitMEX is one of the largest and most popular exchanges, so I had assumed someone would have already put together something in R for accessing data through BitMEX's API. 
As I could find no such package, I drew inspiration from the few 'crypto' related packages that _do_ exist, and set about creating a package that would provide a R users with a set of tools to obtain historic trade data from the exchange..

BitMEX has a very detailed API that allows users to perform essentially every action possible on the site through the API. This ranges from simple queries about historic price data through to executing trades on the platform. 
Initially, I just wanted the package to be able to easily access historic data for research purposes, however it would be relatively straightforward to implement additional features such as executing trades through the API.

And like that, `bitmexr` was born...

Currently you can install `bitmexr` from github, but hopefully the package will be on CRAN soon.

<div class="layout-chunk" data-layout="l-body">
<div class="sourceCode"><pre><code><span class='fu'>remotes</span><span class='fu'>::</span><span class='fu'><a href='https://remotes.r-lib.org/reference/install_github.html'>install_github</a></span><span class='op'>(</span><span class='st'>"hfshr/bitmexr"</span><span class='op'>)</span>
</code></pre></div>

</div>



# bitmexr

`bitmexr` is a relatively simple package that enables the user to obtain data about trades that have been executed on the exchange. The API supports trade data to be returned in two forms:

**Individual trade data**

- Details about individual trades that have taken place on the exchange

**Bucketed trade data**

- A summarised form of individual trade data where individual trades have been "bucketed" into one of the following time intervals; 1-minute, 5-minute, 1-hour or 1-day.

To access this data, `bitmexr` has two core functions:

- `trades()` for individual trade data

<div class="layout-chunk" data-layout="l-body-outset">
<div class="sourceCode"><pre><code><span class='kw'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='op'>(</span><span class='va'><a href='https://github.com/hfshr/bitmexr'>bitmexr</a></span><span class='op'>)</span>
<span class='kw'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='op'>(</span><span class='va'><a href='https://dplyr.tidyverse.org'>dplyr</a></span><span class='op'>)</span>
<span class='kw'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='op'>(</span><span class='va'><a href='https://github.com/rstudio/rmarkdown'>rmarkdown</a></span><span class='op'>)</span>
<span class='kw'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='op'>(</span><span class='va'><a href='https://yihui.org/knitr/'>knitr</a></span><span class='op'>)</span>
<span class='kw'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='op'>(</span><span class='va'><a href='https://github.com/business-science/tidyquant'>tidyquant</a></span><span class='op'>)</span>
<span class='kw'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='op'>(</span><span class='va'><a href='http://purrr.tidyverse.org'>purrr</a></span><span class='op'>)</span>
<span class='kw'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='op'>(</span><span class='va'><a href='https://gganimate.com'>gganimate</a></span><span class='op'>)</span>


<span class='fu'><a href='https://hfshr.github.io/bitmexr//reference/trades.html'>trades</a></span><span class='op'>(</span>symbol <span class='op'>=</span> <span class='st'>"XBTUSD"</span>, count <span class='op'>=</span> <span class='fl'>5</span><span class='op'>)</span> <span class='op'>%&gt;%</span> 
  <span class='fu'><a href='https://dplyr.tidyverse.org/reference/select.html'>select</a></span><span class='op'>(</span><span class='op'>-</span><span class='va'>trdMatchID</span><span class='op'>)</span> <span class='op'>%&gt;%</span> <span class='co'># unique trade identifier, not particularly interesting</span>
  <span class='fu'><a href='https://rdrr.io/pkg/knitr/man/kable.html'>kable</a></span><span class='op'>(</span><span class='op'>)</span>
</code></pre></div>


|timestamp           |symbol |side |  size| price|tickDirection | grossValue| homeNotional| foreignNotional|
|:-------------------|:------|:----|-----:|-----:|:-------------|----------:|------------:|---------------:|
|2020-11-01 10:54:05 |XBTUSD |Sell | 10000| 13754|ZeroMinusTick |   72710000|    0.7271000|           10000|
|2020-11-01 10:54:04 |XBTUSD |Sell |  1263| 13754|ZeroMinusTick |    9183273|    0.0918327|            1263|
|2020-11-01 10:54:04 |XBTUSD |Sell |  1041| 13754|ZeroMinusTick |    7569111|    0.0756911|            1041|
|2020-11-01 10:54:04 |XBTUSD |Sell |   696| 13754|ZeroMinusTick |    5060616|    0.0506062|             696|
|2020-11-01 10:54:01 |XBTUSD |Sell |     1| 13754|MinusTick     |       7271|    0.0000727|               1|

</div>


- `bucket_trades()` for bucketed trade data

<div class="layout-chunk" data-layout="l-page">
<div class="sourceCode"><pre><code><span class='fu'><a href='https://hfshr.github.io/bitmexr//reference/bucket_trades.html'>bucket_trades</a></span><span class='op'>(</span>symbol <span class='op'>=</span> <span class='st'>"XBTUSD"</span>, count <span class='op'>=</span> <span class='fl'>5</span>, binSize <span class='op'>=</span> <span class='st'>"1d"</span><span class='op'>)</span> <span class='op'>%&gt;%</span> 
  <span class='fu'><a href='https://rdrr.io/pkg/knitr/man/kable.html'>kable</a></span><span class='op'>(</span><span class='op'>)</span>
</code></pre></div>


|timestamp  |symbol |    open|    high|     low|   close| trades|     volume|     vwap| lastSize|     turnover| homeNotional| foreignNotional|
|:----------|:------|-------:|-------:|-------:|-------:|------:|----------:|--------:|--------:|------------:|------------:|---------------:|
|2020-11-01 |XBTUSD | 13557.5| 14135.0| 13421.0| 13802.5| 367719| 1772871976| 13762.73|       10| 1.288186e+13|     128818.6|      1772871976|
|2020-10-31 |XBTUSD | 13461.5| 13675.0| 13119.5| 13557.5| 366800| 1884089370| 13401.23|     2879| 1.405910e+13|     140591.0|      1884089370|
|2020-10-30 |XBTUSD | 13268.0| 13638.0| 12983.0| 13461.5| 348667| 1960110483| 13328.00|       12| 1.470738e+13|     147073.8|      1960110483|
|2020-10-29 |XBTUSD | 13642.5| 13854.5| 12905.5| 13268.0| 441363| 2590188154| 13376.14|     3017| 1.936561e+13|     193656.1|      2590188154|
|2020-10-28 |XBTUSD | 13069.0| 13801.5| 13060.0| 13642.5| 385202| 2128904272| 13460.76|        1| 1.581721e+13|     158172.1|      2128904272|

</div>



These functions allow the user to quickly return historic trade/price data that have been executed on the exchange.

## map_* variants

In addition to the core functions, the packages contains map_* variants of each function. These functions were implemented to address two restrictions within the API:

1. The maximum number of rows per API call is limited to 1000
2. The API is limited to 30 requests within a 60 second period

The map_* functions are useful for when the data you wanted to return is greater than the 1000 row limit, but you want to avoid running in to the request limit (too many request timeouts may lead to an IP for up to one week).


For example, say you want to get hourly bucketed trade data from the 2019-01-01 to 2020-01-01.

<div class="layout-chunk" data-layout="l-body">
<div class="sourceCode"><pre><code><span class='fu'><a href='https://hfshr.github.io/bitmexr//reference/bucket_trades.html'>bucket_trades</a></span><span class='op'>(</span>startTime <span class='op'>=</span> <span class='st'>"2019-01-01"</span>, 
              endTime <span class='op'>=</span> <span class='st'>"2020-01-01"</span>, 
              binSize <span class='op'>=</span> <span class='st'>"1h"</span>,
              symbol <span class='op'>=</span> <span class='st'>"XBTUSD"</span><span class='op'>)</span> <span class='op'>%&gt;%</span> 
  <span class='fu'><a href='https://dplyr.tidyverse.org/reference/filter.html'>filter</a></span><span class='op'>(</span><span class='va'>timestamp</span> <span class='op'>==</span> <span class='fu'><a href='https://rdrr.io/r/base/Extremes.html'>max</a></span><span class='op'>(</span><span class='va'>timestamp</span><span class='op'>)</span><span class='op'>)</span> <span class='op'>%&gt;%</span> 
  <span class='fu'><a href='https://dplyr.tidyverse.org/reference/select.html'>select</a></span><span class='op'>(</span><span class='va'>timestamp</span><span class='op'>)</span> <span class='op'>%&gt;%</span> 
  <span class='fu'><a href='https://rdrr.io/pkg/knitr/man/kable.html'>kable</a></span><span class='op'>(</span><span class='op'>)</span>
</code></pre></div>


|timestamp           |
|:-------------------|
|2019-02-11 15:00:00 |

</div>


The first 1000 rows have only returned data up until  2019-02-11. To obtain the rest of the data, you would need to pass in this start date and run the function again, repeating this process until you had the desired time span of data.

This is where the map_* variants come in handy.

<div class="layout-chunk" data-layout="l-page">
<div class="sourceCode"><pre><code><span class='fu'><a href='https://hfshr.github.io/bitmexr//reference/map_bucket_trades.html'>map_bucket_trades</a></span><span class='op'>(</span>start_date <span class='op'>=</span> <span class='st'>"2019-01-01"</span>, 
                  end_date <span class='op'>=</span> <span class='st'>"2020-01-01"</span>, 
                  binSize <span class='op'>=</span> <span class='st'>"1h"</span>,
                  symbol <span class='op'>=</span> <span class='st'>"XBTUSD"</span>,
                  verbose <span class='op'>=</span> <span class='cn'>FALSE</span><span class='op'>)</span> <span class='op'>%&gt;%</span> 
  <span class='fu'><a href='https://rdrr.io/pkg/rmarkdown/man/paged_table.html'>paged_table</a></span><span class='op'>(</span><span class='op'>)</span>
</code></pre></div>
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
  </script>
</div>

</div>


If verbose is set to `TRUE` information about what is going on and a progress bar showing how long is left is printed to the console.
Now the end date is what we wanted.

`map_trades()` works in a similar way, however because the number of each trades for a specified time interval is not known in advance, no progress bar is printed. Instead, the last date of the most recent API call is printed to provide an indication of how long is left (relative to the inputted start and end date). This function uses a repeat loop that will keep calling the API until the start date is greater than the end date.

The following example gets the every trade for "XBTUSD" between 12:00 and 12:15 on the 6th June 2019.

<div class="layout-chunk" data-layout="l-page">
<div class="sourceCode"><pre><code><span class='fu'><a href='https://hfshr.github.io/bitmexr//reference/map_trades.html'>map_trades</a></span><span class='op'>(</span>symbol <span class='op'>=</span> <span class='st'>"XBTUSD"</span>,
           start_date <span class='op'>=</span> <span class='st'>"2019-06-01 12:00:00"</span>,
           end_date <span class='op'>=</span> <span class='st'>"2019-06-01 12:15:00"</span><span class='op'>)</span> <span class='op'>%&gt;%</span> 
  <span class='fu'><a href='https://dplyr.tidyverse.org/reference/select.html'>select</a></span><span class='op'>(</span><span class='op'>-</span><span class='va'>trdMatchID</span><span class='op'>)</span> <span class='op'>%&gt;%</span> <span class='co'># unique trade identifier, not particularly interesting</span>
  <span class='fu'><a href='https://rdrr.io/pkg/rmarkdown/man/paged_table.html'>paged_table</a></span><span class='op'>(</span><span class='op'>)</span>
</code></pre></div>
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
  </script>
</div>

</div>


This short 15 minute time interval resulted in ~6000 trades being returned - consequently this function should only be used for very specific time intervals where you require individual trade data. 
A warning is given if a time interval of greater than 1 day is provided. For example:

<div class="layout-chunk" data-layout="l-body">
<div class="sourceCode"><pre><code><span class='fu'><a href='https://rdrr.io/pkg/knitr/man/include_graphics.html'>include_graphics</a></span><span class='op'>(</span><span class='st'>"images/warning.png"</span><span class='op'>)</span>
</code></pre></div>
<img src="images/warning.png" width="100%" />

</div>


In contrast, using `bucket_trades()` with the smallest binSize setting summarises those 6000 rows into 16 - one for each minute between 12:00 and 12:15. 

<div class="layout-chunk" data-layout="l-page">
<div class="sourceCode"><pre><code><span class='fu'><a href='https://hfshr.github.io/bitmexr//reference/bucket_trades.html'>bucket_trades</a></span><span class='op'>(</span>symbol <span class='op'>=</span> <span class='st'>"XBTUSD"</span>,
              startTime <span class='op'>=</span> <span class='st'>"2019-06-01 12:00:00"</span>,
              endTime <span class='op'>=</span> <span class='st'>"2019-06-01 12:15:00"</span>,
              binSize <span class='op'>=</span> <span class='st'>"1m"</span><span class='op'>)</span> <span class='op'>%&gt;%</span> 
  <span class='fu'><a href='https://rdrr.io/pkg/rmarkdown/man/paged_table.html'>paged_table</a></span><span class='op'>(</span><span class='op'>)</span>
</code></pre></div>
<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["timestamp"],"name":[1],"type":["dttm"],"align":["right"]},{"label":["symbol"],"name":[2],"type":["chr"],"align":["left"]},{"label":["open"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["high"],"name":[4],"type":["dbl"],"align":["right"]},{"label":["low"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["close"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["trades"],"name":[7],"type":["int"],"align":["right"]},{"label":["volume"],"name":[8],"type":["int"],"align":["right"]},{"label":["vwap"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["lastSize"],"name":[10],"type":["int"],"align":["right"]},{"label":["turnover"],"name":[11],"type":["dbl"],"align":["right"]},{"label":["homeNotional"],"name":[12],"type":["dbl"],"align":["right"]},{"label":["foreignNotional"],"name":[13],"type":["int"],"align":["right"]}],"data":[{"1":"2019-06-01 12:00:00","2":"XBTUSD","3":"8575.0","4":"8574.5","5":"8574.0","6":"8574.5","7":"144","8":"185242","9":"8574.859","10":"1","11":"2160422436","12":"21.60422","13":"185242"},{"1":"2019-06-01 12:01:00","2":"XBTUSD","3":"8574.5","4":"8583.0","5":"8574.0","6":"8582.5","7":"588","8":"1230640","9":"8579.272","10":"50","11":"14345142048","12":"143.45142","13":"1230640"},{"1":"2019-06-01 12:02:00","2":"XBTUSD","3":"8582.5","4":"8583.0","5":"8582.5","6":"8582.5","7":"267","8":"1048616","9":"8582.954","10":"1000","11":"12217666831","12":"122.17667","13":"1048616"},{"1":"2019-06-01 12:03:00","2":"XBTUSD","3":"8582.5","4":"8583.5","5":"8582.5","6":"8583.5","7":"246","8":"661857","9":"8583.691","10":"1000","11":"7710989100","12":"77.10989","13":"661857"},{"1":"2019-06-01 12:04:00","2":"XBTUSD","3":"8583.5","4":"8597.5","5":"8583.0","6":"8592.0","7":"1695","8":"5620098","9":"8591.065","10":"500","11":"65422522266","12":"654.22522","13":"5620098"},{"1":"2019-06-01 12:05:00","2":"XBTUSD","3":"8592.0","4":"8594.5","5":"8592.0","6":"8594.0","7":"292","8":"777814","9":"8594.019","10":"1","11":"9051152323","12":"90.51152","13":"777814"},{"1":"2019-06-01 12:06:00","2":"XBTUSD","3":"8594.0","4":"8594.5","5":"8589.5","6":"8589.5","7":"360","8":"778688","9":"8592.542","10":"2000","11":"9062796910","12":"90.62797","13":"778688"},{"1":"2019-06-01 12:07:00","2":"XBTUSD","3":"8589.5","4":"8589.5","5":"8588.0","6":"8588.5","7":"247","8":"371721","9":"8589.589","10":"1000","11":"4327917840","12":"43.27918","13":"371721"},{"1":"2019-06-01 12:08:00","2":"XBTUSD","3":"8588.5","4":"8588.5","5":"8586.0","6":"8586.5","7":"219","8":"390563","9":"8587.377","10":"500","11":"4548215048","12":"45.48215","13":"390563"},{"1":"2019-06-01 12:09:00","2":"XBTUSD","3":"8586.5","4":"8586.5","5":"8584.5","6":"8585.0","7":"217","8":"507714","9":"8585.902","10":"700","11":"5913809324","12":"59.13809","13":"507714"},{"1":"2019-06-01 12:10:00","2":"XBTUSD","3":"8585.0","4":"8585.0","5":"8583.5","6":"8583.5","7":"164","8":"250188","9":"8584.428","10":"500","11":"2914579596","12":"29.14580","13":"250188"},{"1":"2019-06-01 12:11:00","2":"XBTUSD","3":"8583.5","4":"8584.0","5":"8583.0","6":"8583.0","7":"103","8":"232592","9":"8583.691","10":"300","11":"2709734325","12":"27.09734","13":"232592"},{"1":"2019-06-01 12:12:00","2":"XBTUSD","3":"8583.0","4":"8583.5","5":"8583.0","6":"8583.0","7":"134","8":"334623","9":"8583.691","10":"81196","11":"3898470401","12":"38.98470","13":"334623"},{"1":"2019-06-01 12:13:00","2":"XBTUSD","3":"8583.0","4":"8583.5","5":"8583.0","6":"8583.0","7":"170","8":"683997","9":"8583.691","10":"25","11":"7969147973","12":"79.69148","13":"683997"},{"1":"2019-06-01 12:14:00","2":"XBTUSD","3":"8583.0","4":"8583.0","5":"8582.5","6":"8583.0","7":"101","8":"235333","9":"8582.954","10":"6200","11":"2742071411","12":"27.42071","13":"235333"},{"1":"2019-06-01 12:15:00","2":"XBTUSD","3":"8583.0","4":"8583.0","5":"8579.0","6":"8579.0","7":"411","8":"1110524","9":"8581.481","10":"51","11":"12941947207","12":"129.41947","13":"1110524"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

</div>


## Use with other packages

`bitmexr` simply allows the user to _get_ the data. With data in hand, there are several fantastic packages that can be used to help explore, visualise the data further. Two personal favourites are `tidyquant`[@R-tidyquant] and `gganimate`[@R-gganimate].

Combining `bitmexr` and `tidyquant` makes it easy to perform financial analysis. For example, comparing the monthly returns of the two most traded contracts on Bitmex

<div class="layout-chunk" data-layout="l-body">
<div class="sourceCode"><pre><code><span class='va'>btc_year</span> <span class='op'>&lt;-</span> <span class='fu'><a href='https://purrr.tidyverse.org/reference/map.html'>map_dfr</a></span><span class='op'>(</span><span class='fu'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='op'>(</span><span class='st'>"XBTUSD"</span>, <span class='st'>"ETHUSD"</span><span class='op'>)</span>, <span class='op'>~</span><span class='fu'><a href='https://hfshr.github.io/bitmexr//reference/map_bucket_trades.html'>map_bucket_trades</a></span><span class='op'>(</span>symbol <span class='op'>=</span> <span class='va'>.x</span>,
                                                              binSize <span class='op'>=</span> <span class='st'>"1d"</span><span class='op'>)</span><span class='op'>)</span>

<span class='va'>btc_year</span> <span class='op'>%&gt;%</span> 
  <span class='fu'><a href='https://dplyr.tidyverse.org/reference/filter.html'>filter</a></span><span class='op'>(</span><span class='va'>timestamp</span> <span class='op'>&gt;</span> <span class='st'>"2018-08-01"</span><span class='op'>)</span> <span class='op'>%&gt;%</span> <span class='co'># ETHUSD only available since August 2018</span>
  <span class='fu'><a href='https://dplyr.tidyverse.org/reference/group_by.html'>group_by</a></span><span class='op'>(</span><span class='va'>symbol</span><span class='op'>)</span> <span class='op'>%&gt;%</span> 
  <span class='fu'><a href='https://rdrr.io/pkg/tidyquant/man/tq_mutate.html'>tq_transmute</a></span><span class='op'>(</span>select <span class='op'>=</span> <span class='va'>close</span>,
               mutate_fun <span class='op'>=</span> <span class='va'>periodReturn</span>,
               period <span class='op'>=</span> <span class='st'>"monthly"</span>,
               type <span class='op'>=</span> <span class='st'>"log"</span>,
               col_rename <span class='op'>=</span> <span class='st'>"monthly_returns"</span><span class='op'>)</span> <span class='op'>%&gt;%</span> 
  <span class='fu'>ggplot</span><span class='op'>(</span><span class='fu'>aes</span><span class='op'>(</span>x <span class='op'>=</span> <span class='va'>timestamp</span>, y <span class='op'>=</span> <span class='va'>monthly_returns</span>, fill <span class='op'>=</span> <span class='va'>symbol</span><span class='op'>)</span><span class='op'>)</span> <span class='op'>+</span>
  <span class='fu'>geom_bar</span><span class='op'>(</span>position <span class='op'>=</span> <span class='st'>"dodge"</span>, stat <span class='op'>=</span> <span class='st'>"identity"</span><span class='op'>)</span> <span class='op'>+</span>
  <span class='fu'>scale_y_continuous</span><span class='op'>(</span>labels <span class='op'>=</span> <span class='fu'>scales</span><span class='fu'>::</span><span class='va'><a href='https://scales.r-lib.org//reference/label_percent.html'>percent</a></span><span class='op'>)</span> <span class='op'>+</span>
  <span class='fu'><a href='https://rdrr.io/pkg/tidyquant/man/theme_tq.html'>theme_tq</a></span><span class='op'>(</span><span class='op'>)</span>
</code></pre></div>
<img src="bitmexr_files/figure-html5/unnamed-chunk-9-1.png" width="624" />

</div>



`gganimate` makes it easy to visualise those exciting (or worrisome, depending which side of the trade you were on...!) periods of high volatility.

A personal favourite was the parabolic rise in late 2017...

<div class="layout-chunk" data-layout="l-body-outset">
<div class="sourceCode"><pre><code><span class='va'>vol</span> <span class='op'>&lt;-</span> <span class='fu'><a href='https://hfshr.github.io/bitmexr//reference/map_bucket_trades.html'>map_bucket_trades</a></span><span class='op'>(</span>start_date <span class='op'>=</span> <span class='st'>"2017-08-05"</span>,
                         end_date <span class='op'>=</span> <span class='st'>"2017-12-25"</span>,
                         symbol <span class='op'>=</span> <span class='st'>"XBTUSD"</span>,
                         binSize <span class='op'>=</span> <span class='st'>"1h"</span><span class='op'>)</span>


<span class='va'>p</span> <span class='op'>&lt;-</span> <span class='va'>vol</span> <span class='op'>%&gt;%</span> 
  <span class='fu'><a href='https://dplyr.tidyverse.org/reference/filter.html'>filter</a></span><span class='op'>(</span><span class='va'>timestamp</span> <span class='op'>&lt;=</span> <span class='st'>"2017-12-17"</span><span class='op'>)</span> <span class='op'>%&gt;%</span> 
  <span class='fu'>ggplot</span><span class='op'>(</span><span class='fu'>aes</span><span class='op'>(</span>x <span class='op'>=</span> <span class='va'>timestamp</span>, y <span class='op'>=</span> <span class='va'>close</span><span class='op'>)</span><span class='op'>)</span> <span class='op'>+</span>
  <span class='fu'><a href='https://rdrr.io/pkg/tidyquant/man/geom_chart.html'>geom_candlestick</a></span><span class='op'>(</span><span class='fu'>aes</span><span class='op'>(</span>open <span class='op'>=</span> <span class='va'>open</span>, high <span class='op'>=</span> <span class='va'>high</span>, low <span class='op'>=</span> <span class='va'>low</span>, close<span class='op'>=</span> <span class='va'>close</span><span class='op'>)</span>,
                   fill_up <span class='op'>=</span> <span class='st'>"green"</span>,
                   fill_down <span class='op'>=</span> <span class='st'>"red"</span>,
                   colour_up <span class='op'>=</span> <span class='st'>"green"</span>,
                   colour_down <span class='op'>=</span> <span class='st'>"red"</span><span class='op'>)</span> <span class='op'>+</span>
  <span class='fu'>scale_y_continuous</span><span class='op'>(</span>labels <span class='op'>=</span> <span class='fu'>scales</span><span class='fu'>::</span><span class='va'><a href='https://scales.r-lib.org//reference/label_dollar.html'>dollar</a></span><span class='op'>)</span> <span class='op'>+</span>
  <span class='fu'><a href='https://gganimate.com/reference/transition_time.html'>transition_time</a></span><span class='op'>(</span><span class='va'>timestamp</span><span class='op'>)</span> <span class='op'>+</span>
  <span class='fu'><a href='https://gganimate.com/reference/shadow_mark.html'>shadow_mark</a></span><span class='op'>(</span><span class='op'>)</span> <span class='op'>+</span>
  <span class='fu'>theme_minimal</span><span class='op'>(</span><span class='op'>)</span> <span class='op'>+</span>
  <span class='fu'><a href='https://gganimate.com/reference/view_follow.html'>view_follow</a></span><span class='op'>(</span><span class='op'>)</span>

<span class='fu'><a href='https://gganimate.com/reference/animate.html'>animate</a></span><span class='op'>(</span><span class='va'>p</span>, end_pause <span class='op'>=</span> <span class='fl'>5</span><span class='op'>)</span>
</code></pre></div>
![](bitmexr_files/figure-html5/gganimate-1.gif)<!-- -->

</div>



...but I'll spare the pain of showing what came next...!
```{.r .distill-force-highlighting-css}
```