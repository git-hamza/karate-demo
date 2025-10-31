function fn() {
  var env = karate.env || 'dev';
  karate.log('Running in environment:', env);

  var config = {};

  // explicit environment URLs and Kafka settings
  if (env === 'dev') {
    config.baseUrl = 'https://jsonplaceholder.typicode.com';
    config.kafka = { broker: 'localhost:9092', topic: 'todo-dev-topic' };
  } else if (env === 'stage') {
    config.baseUrl = 'https://jsonplaceholder.typicode.com';
    config.kafka = { broker: 'stage.kafka:9093', topic: 'todo-stage-topic' };
  } else if (env === 'qa') {
    config.baseUrl = 'https://qa.api.placeholder.com';
    config.kafka = { broker: 'qa.kafka:9092', topic: 'todo-qa-topic' };
  } else if (env === 'prod') {
    config.baseUrl = 'https://api.placeholder.com';
    config.kafka = { broker: 'prod.kafka:9092', topic: 'todo-prod-topic' };
  } else {
    // fallback to dev-like defaults if an unknown env is used
    config.baseUrl = 'https://jsonplaceholder.typicode.com';
    config.kafka = { broker: 'localhost:9092', topic: 'todo-dev-topic' };
  }
  config.kafka.username = karate.properties['kafka.user'];
  config.kafka.password = karate.properties['kafka.pass'];
  // enable a simple in-memory mock by default (set -Dkafka.mock=false to use a real broker)
  config.kafka.mock = karate.properties['kafka.mock'] ? (karate.properties['kafka.mock'] == 'true') : true;
  // default consume timeout in milliseconds (override with -Dkafka.timeout=8000)
  config.kafka.timeout = karate.properties['kafka.timeout'] ? Number(karate.properties['kafka.timeout']) : 5000;
  return config;
}