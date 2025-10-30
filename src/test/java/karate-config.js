function fn() {
  var env = karate.env || 'dev';
  karate.log('Running in environment:', env);

  var config = {};

  if (env === 'dev') {
    config.baseUrl = 'https://jsonplaceholder.typicode.com';
    config.kafka = {
      broker: 'localhost:9092',
      topic: 'todo-dev-topic',
    };
  } else if (env === 'stage') {
    config.baseUrl = 'https://jsonplaceholder.typicode.com';
    config.kafka = {
      broker: 'stage.kafka:9093',
      topic: 'todo-stage-topic',
    };
  }
  config.kafka.username = karate.properties['kafka.user'];
  config.kafka.password = karate.properties['kafka.pass'];
  return config;
}