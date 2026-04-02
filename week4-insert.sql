-- Week 4 Quiz: Chapter 10 - Monitoring Kafka
-- Run this in Supabase SQL Editor (Dashboard > SQL Editor)

INSERT INTO quizzes (week_number, title, description, questions)
VALUES (
  4,
  'Chapter 10: Monitoring Kafka',
  'Monitoring Kafka - Test your knowledge of broker SLIs, producer and consumer metrics, consumer lag monitoring, and end-to-end cluster health.',
  '[
    {
      "q": "According to the book, if you could only monitor ONE metric from a Kafka broker, which should it be?",
      "options": [
        "Active controller count",
        "Under-replicated partitions",
        "All topics bytes in per second",
        "Request handler idle ratio"
      ],
      "answer": 1,
      "explanation": "The book states: ''If there is only one metric that you are able to monitor from the Kafka broker, it should be the number of under-replicated partitions.'' This single metric provides insight into a wide variety of problems — from a broker being down to resource exhaustion. A non-zero value means follower replicas are not caught up with their leaders, which warrants immediate investigation."
    },
    {
      "q": "Which two producer metrics does the book recommend setting alerts on for production monitoring?",
      "options": [
        "outgoing-byte-rate and record-send-rate",
        "record-error-rate and request-latency-avg",
        "batch-size-avg and record-queue-time-avg",
        "request-rate and records-per-request-avg"
      ],
      "answer": 1,
      "explanation": "The book identifies record-error-rate and request-latency-avg as the two critical producer metrics to alert on. record-error-rate should always be zero — if it''s not, the producer is dropping messages after exhausting retries. request-latency-avg measures how long produce requests take; an increase signals networking issues or broker problems that will cause back-pressure in your application."
    },
    {
      "q": "Why does the book recommend using an external system like Burrow for consumer lag monitoring instead of relying on the consumer client''s built-in records-lag-max metric?",
      "options": [
        "records-lag-max is only available in the Java client, not in other language clients",
        "records-lag-max only shows the lag for the single most-behind partition and requires the consumer to be functioning properly to report it",
        "records-lag-max measures lag in bytes rather than messages, making it less useful",
        "records-lag-max has a significant performance overhead that slows down consumption"
      ],
      "answer": 1,
      "explanation": "The book explains two problems with records-lag-max: it only represents a single partition (the one that is most behind), so it doesn''t accurately show how far behind the overall consumer is. More critically, it relies on proper operation of the consumer — if the consumer is broken or offline, the metric is either inaccurate or unavailable. External monitoring like Burrow can track lag regardless of consumer status by comparing broker offsets with committed consumer offsets."
    },
    {
      "q": "Why does the book caution against setting minimum threshold alerts on consumer bytes-consumed-rate and records-consumed-rate?",
      "options": [
        "These metrics are too noisy and fluctuate too rapidly to be useful for alerting",
        "The consumer''s consumption rate depends on the producer — if the producer stops sending, low consumption is expected, not a problem, leading to false alerts",
        "These metrics are only updated once per minute, making them too slow for real-time alerting",
        "Consumer rate metrics include internal Kafka protocol overhead, making the numbers unreliable"
      ],
      "answer": 1,
      "explanation": "The book warns that Kafka is designed to decouple producers and consumers, allowing them to operate independently. The rate at which a consumer processes messages depends on whether the producer is sending them. Setting a minimum threshold on consumption rate means you''re implicitly making assumptions about the producer''s behavior, which can lead to false alerts when the producer legitimately slows down or stops."
    },
    {
      "q": "What does end-to-end monitoring of a Kafka cluster verify that broker metrics and client metrics alone cannot?",
      "options": [
        "That the Zookeeper ensemble is healthy and responding to requests",
        "That messages can actually be produced to and consumed from the cluster from a client''s point of view — verifying the full data path works",
        "That all topic partitions have the correct replication factor configured",
        "That consumer group offsets are being committed at the correct interval"
      ],
      "answer": 1,
      "explanation": "The book explains that broker and client metrics can indicate a problem, but increased latency could be the client, the network, or Kafka itself. End-to-end monitoring (like LinkedIn''s Kafka Monitor) answers the two fundamental questions: ''Can I produce messages to the cluster?'' and ''Can I consume messages from the cluster?'' It does this by continuously producing and consuming from a test topic spread across all brokers, measuring availability and latency from a client perspective — something internal broker metrics simply cannot provide."
    }
  ]'::jsonb
);
