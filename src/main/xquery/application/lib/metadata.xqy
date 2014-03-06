xquery version "1.0-ml";

module namespace meta = "http://marklogic.com/sem-app/metadata";

import module namespace data = "http://marklogic.com/sem-app/data"
    at "/lib/data-access.xqy";

import module namespace infobox = "http://marklogic.com/sem-app/infobox"
    at "/lib/infobox.xqy";

import module namespace search = "http://marklogic.com/appservices/search"
    at "/MarkLogic/appservices/search/search.xqy";

declare default function namespace "http://www.w3.org/2005/xpath-functions";

declare option xdmp:mapping "false";

declare function meta:categories($uri, $results) {
  let $categories :=
    distinct-values(
      xdmp:document-properties($uri)//sem:triple
                                      [sem:predicate eq 'http://s.opencalais.com/1/pred/categoryName']
                                     /sem:object
    )
  ! (
     let $cat := .
     return $results/search:facet[@name eq 'cat']/search:facet-value[@name eq $cat]
    )
  return
    for $c in $categories order by $c/@name return $c
};

declare function meta:tags($uri, $results) {
   
   let $doc-id := doc($uri)/*:html/*:head/@resource/string()
                
   let $log := xdmp:log(fn:concat("***************** DOC-ID: ",$doc-id))             
                                  
   let $tags :=
   sem:sparql("

    PREFIX c:   <http://s.opencalais.com/1/pred/>
    PREFIX r:   <http://s.opencalais.com/1/type/er/>
    PREFIX owl: <http://www.w3.org/2002/07/owl#>
    PREFIX dbpedia-owl: <http://dbpedia.org/ontology>
    PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
    PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

    SELECT DISTINCT ?label
    WHERE {
      ?DocInfo owl:sameAs <"||$doc-id||"> .
      ?subject c:docId ?DocInfo;
               ?pred ?link .
      ?link rdf:type ?obj;
            rdfs:label ?label .
      
      }
   ")
   ! map:get(., "label")
   
   return 
   
   for $tag in $tags return <tag name="test">{$tag}</tag>
};

(: declare function meta:categories($uri, $results) {

let $doc-id := doc($uri)/*:html/*:head/@resource/string()
let $categories :=
  sem:sparql("

    PREFIX c:   <http://s.opencalais.com/1/pred/>
    PREFIX r:   <http://s.opencalais.com/1/type/er/>
    PREFIX owl: <http://www.w3.org/2002/07/owl#>

    SELECT DISTINCT ?cat
    WHERE {
      ?DocInfo owl:sameAs <"||$doc-id||"> .

      ?DocCat c:docId ?DocInfo ;
              c:categoryName ?cat .

    }
  ")
  ! map:get(., "cat")
  ! (
     let $cat := .
     return $results/search:facet[@name eq 'cat']/search:facet-value[@name eq $cat]
    )
  return
    for $c in $categories order by $c/@name return $c
}; :)


(:
declare function meta:data($uri) {
  let $doc-id := doc($uri)/*:html/*:head/@resource/string()
  return
    sem:sparql("

PREFIX c:   <http://s.opencalais.com/1/pred/>
PREFIX r:   <http://s.opencalais.com/1/type/er/>
PREFIX owl: <http://www.w3.org/2002/07/owl#>

SELECT DISTINCT ?equiv
WHERE {
  ?DocInfo owl:sameAs <"||$doc-id||"> .

  ?thing c:docId ?DocInfo ;
         owl:sameAs ?equiv .

  ?thing a ?type . FILTER (sameTerm(?type,r:Company) || sameTerm(?type,r:Country) 
}
")
! map:get(., "equiv")
! (if (starts-with(.,"http://dbpedia.org")) then . else ())
! <thing></thing>
};
:)
