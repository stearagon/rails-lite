# Rails-Lite
  This is a stripped down version of the Rails Controller and Router functionality.
  
  There are six test servers you can run to see examples of the different functions:<br>
  * renders html/erb template <br>
  * invoke the proper action from url address <br>
  * stores cookies <br>
  * parses params from three different sources

## Languages
  - Ruby
  - Regex

## Technical Implementation
  To demonstrate Rails-Lite functionality, I used the WEBrick web-server that is
  included with Ruby. Webrick allows us to see the request and deliver a response.

  I used ERB, the template rendering library that is included in Ruby, to take html
  templates that include Ruby code and render it in the response.

  WEBrick allows us to read request cookies and add cookies to the response.

  One of the more challenging parts of this project was dealing with Params. Request
  body params can have nested keys, which are more difficult to parse. I used a
  a combination or regex and URI::decode_www_form to handle the nested keys.

  To make routes, I used Ruby meta-programming techniques to create routes that used
  the main http methods (:get, :post, :put, :delete).


## Future Features
  - Flash
  - CSRF Protection
