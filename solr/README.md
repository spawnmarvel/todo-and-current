# Solr


## Solr delete index

http://localhost:8983/solr

```xml
<delete><query>*:*</query></delete>
```

If you get a IndexWriter is Closed

* stop tomcat, solr
* remove file write.lock
* start tomcat, solr

And run the document delete all again.

Document Type: XML

🔹 Command Used: <delete><query>*:*</query></delete>
🔹 Parameters: commitWithin=1000 (meaning changes will be permanently written/committed to the index within 1000 milliseconds) and overwrite=true.
🔹 Status: success with a status: 0 response, indicating the query executed perfectly and wiped the index clean.

![management](https://github.com/spawnmarvel/todo-and-current/blob/main/solr/images/solr.png)