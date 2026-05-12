# RabbitMQ

## Shovel is denfined in quick guides

## Concepts

## Why it’s Useful in Hybrid Environments

In environments where you manage both Azure cloud and on-prem servers, RabbitMQ is often used to:

* Bridge Networks: Use a "Shovel" or "Federation" plugin to move messages between local servers and the cloud reliably.

* Handle Traffic Spikes: It acts as a buffer. If your web server gets hit with 10,000 requests at once, RabbitMQ holds them in a queue so your database isn't overwhelmed.  

* Monitoring Integration: You can feed system events into RabbitMQ and have them consumed by tools like Zabbix or Grafana Loki for centralized logging.

## RabbitMQ tutorial - "Hello world!" Introduction

```txt
admin2
Limaecho456.
```

https://www.rabbitmq.com/tutorials/tutorial-one-python

## RabbitMQ tutorial - Work Queues

https://www.rabbitmq.com/tutorials/tutorial-two-python


## RabbitMQ tutorial - Publish/Subscribe


https://www.rabbitmq.com/tutorials/tutorial-three-python


## RabbitMQ tutorial - Routing

https://www.rabbitmq.com/tutorials/tutorial-four-python

## RabbitMQ tutorial - Topics


https://www.rabbitmq.com/tutorials/tutorial-five-python

## RabbitMQ tutorial - Remote procedure call (RPC)


https://www.rabbitmq.com/tutorials/tutorial-six-python