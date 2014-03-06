xquery version "1.0-ml";


"Doc from XQuery:",
doc('content/news/world-asia-china-23081653.xml'),

(:This works in 0906 build but not 0926 :)
xdmp:xslt-invoke("/lib/test.xsl", document{<empty/>})
