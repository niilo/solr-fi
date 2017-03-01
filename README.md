
# SOLR-FI docker container with Voikko Finnish language library

## Run SOLR-FI docker container

Start solr with fi-biblio core listening on port 8983.
```bash
./docker-run.sh
```

## Voikko natural language tool usage

Start using Voikko with the following filter declaration in Solr schema configuration:
```xml
<filter class="fi.nationallibrary.ndl.solrvoikko2.VoikkoFilterFactory" expandCompounds="true" allAnalysis="true"/>
```

The following options are available for configuring the behavior of Voikko plugin:
* __minWordSize__ - Minimum word length to analyze. Shorter words are ignored. *Default is 3.*
* __expandCompounds__ - If true, compound words are also split (e.g. term "kuohuviiniä" is analyzed to "kuohuviini" and "kuohu" + "viini". *Default is false.*
* __minSubwordSize__ - Minimum split compound word length to accept. Shorter words are discarded. *Default is 2.*
* __maxSubwordSize__ - Maximum split compound word length to accept. Longer words are truncated. *Default is 25.*
* __allAnalysis__ - If true, all possible analysis of the word are used. *Default is false* meaning only the first analysis is used.
* __cacheSize__ - Defines the number of analysis to keep in a shared cache. The cache helps avoid repeated analysis of a term. *Default is 1024*, but cache sizes up to hundreds of thousands could boost the performance since Voikko analysis is a relatively slow process.
* __statsInterval__ - Defines the token interval to use when logging statistics. *Default is 100000*. Statistics are written in the Solr log and may help in fine-tuning the cache size. Set to 0 to disable stats.
* __dictionaryPath__ - Path pointing to Voikko dictionaries. This path is searched before the standard locations (e.g. /etc/voikko). Note that the package includes a small test app that can be used to display results of Voikko analysis. 

See more details here: https://github.com/NatLibFi/SolrPlugins/wiki/Voikko-plugin (bit outdated?)

Example text field with Finnish language (https://github.com/NatLibFi/NDL-VuFind-Solr/blob/master/vufind/biblio/conf/schema.xml)
```xml
<fieldType name="text" class="solr.TextField" positionIncrementGap="100">
    <similarity class="solr.ClassicSimilarityFactory"/>
    <analyzer type="index">
      <tokenizer class="solr.ICUTokenizerFactory"/>
      <filter class="solr.LowerCaseFilterFactory"/>
      <filter class="solr.WordDelimiterFilterFactory" generateWordParts="1" generateNumberParts="1" catenateWords="1" catenateNumbers="1" catenateAll="0" splitOnCaseChange="0" protected="delim_protected.txt"/>
      <filter class="fi.nationallibrary.ndl.solrvoikko2.VoikkoFilterFactory" expandCompounds="true" allAnalysis="true" cacheSize="2500" statsInterval="0"/>
      <filter class="solr.CommonGramsFilterFactory" words="stopwords.txt" ignoreCase="true"/>
      <filter class="solr.StopFilterFactory" ignoreCase="true" words="stopwords.txt"/>
      <charFilter class="solr.MappingCharFilterFactory" mapping="mapping-FoldToASCII_fi.txt"/>
      <filter class="solr.KeywordMarkerFilterFactory" protected="protwords.txt"/>
      <filter class="solr.EnglishMinimalStemFilterFactory"/>
      <filter class="solr.RemoveDuplicatesTokenFilterFactory"/>
    </analyzer>
    <analyzer type="query">
      <tokenizer class="solr.ICUTokenizerFactory"/>
      <filter class="solr.LowerCaseFilterFactory"/>
      <filter class="solr.WordDelimiterFilterFactory" generateWordParts="1" generateNumberParts="1" catenateWords="0" catenateNumbers="0" catenateAll="0" splitOnCaseChange="0" protected="delim_protected.txt"/>
      <filter class="solr.SynonymFilterFactory" synonyms="synonyms.txt" ignoreCase="true" expand="true"/>
      <filter class="fi.nationallibrary.ndl.solrvoikko2.VoikkoFilterFactory" expandCompounds="true" allAnalysis="true"/>
      <filter class="solr.CommonGramsQueryFilterFactory" words="stopwords.txt" ignoreCase="true"/>
      <filter class="solr.StopFilterFactory" ignoreCase="true" words="stopwords.txt"/>
      <charFilter class="solr.MappingCharFilterFactory" mapping="mapping-FoldToASCII_fi.txt"/>
      <filter class="solr.KeywordMarkerFilterFactory" protected="protwords.txt"/>
      <filter class="solr.EnglishMinimalStemFilterFactory"/>
      <filter class="solr.RemoveDuplicatesTokenFilterFactory"/>
    </analyzer>
  </fieldType>
```

Voikko Solr plugin (https://github.com/niilo/SolrPlugins) uses LibVoikko (https://github.com/voikko/corevoikko/tree/master/libvoikko)