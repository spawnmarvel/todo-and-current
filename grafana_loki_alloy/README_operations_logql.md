# Query Loki



https://grafana.com/docs/loki/latest/query/

## Grafana Logs Drilldown

Grafana Logs Drilldown to automatically visualize your log data. 

Logs Drilldown uses default queries to provide a set of initial visualizations that display information 

## Grafana Explore

Grafana Explore helps you examine your data ad-hoc or build and refine a LogQL query for inclusion within a dashboard.

## LogQL

LogQL is the query language for Grafana Loki. 

Since Loki doesn’t require a strict schema or structure for log information up front, LogQL allows you to create a “schema at query”. 

***This means that a schema for a log line is inferred when you write a query, rather than when a log line is ingested.***

A Loki log consists of:

* a timestamp
* labels/selectors
* content of the log line.

Loki indexes the timestamp and labels, but not the rest of the log line.

LogQL queries are in the following format:

```loqql 
{ log stream selector } | log pipeline
```
### Log stream selector:

The log stream selector, also called label selector, is a string containing key-value pairs like this:

```loqql 
{service_name="nginx", status="500"}
```

### Log Pipeline

### Filter expressions

### Parser expressions

### Format expressions

## Types of LogQL queries

There are two types of LogQL queries:

* Log queries return the contents of log lines.
* Metric queries let you create metrics from logs.
* 
Log queries are queries whose output remains strings, structured or otherwise. They use the log stream selector and log pipeline construction and can be chained together to create longer log queries.

Metric queries calculate values based on the log results returned.