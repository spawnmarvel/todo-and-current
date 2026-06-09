# Solr


## Solr delete index

http://localhost:8983/solr



If you get a IndexWriter is Closed

* stop tomcat, solr
* remove file write.lock
* start tomcat, solr

And run the document delete all again.

Method 1: Using the Solr Admin UI
You can clear the index directly from the browser administration panel.

🔹 1. Open your browser and navigate to your Solr Admin dashboard (typically http://localhost:8983/solr/).

🔹 2. Select your specific core or collection from the Core/Collection Selector dropdown menu on the left side panel.

🔹 3. Click on the Documents tab.

🔹 4. Change the Document Type dropdown setting to XML.

🔹 5. In the Document(s) text area box, input the following text exactly:

```xml
<delete><query>*:*</query></delete>
```
🔹 6. Ensure that the Commit Within value is specified (e.g., 1000) or pass a clean hard commit parameter if desired.

🔹 7. Click the Submit Document button. The right-hand panel will display a success block message matching status: 0

![management](https://github.com/spawnmarvel/todo-and-current/blob/main/solr/images/solr.png)