-- Week 3 Quiz: Chapter 4 - Kafka Consumers
-- Run this in Supabase SQL Editor (Dashboard > SQL Editor)

INSERT INTO quizzes (week_number, title, description, questions)
VALUES (
  3,
  'Chapter 4: Kafka Consumers',
  'Reading Data from Kafka - Test your knowledge of consumer groups, partition rebalancing, offset management, deserializers, and standalone consumers.',
  '[
    {
      "q": "What happens when you add more consumers to a consumer group than there are partitions in the topic?",
      "options": [
        "Kafka automatically creates new partitions to match the number of consumers",
        "The extra consumers will sit idle and receive no messages",
        "Messages are duplicated so every consumer gets a copy",
        "The extra consumers become backup replicas"
      ],
      "answer": 1,
      "explanation": "Each partition can only be assigned to one consumer within a group. If you have more consumers than partitions, the extras will be idle. This is why it''s a good reason to create topics with a large number of partitions — it allows adding more consumers when load increases."
    },
    {
      "q": "How do consumers maintain their membership in a consumer group?",
      "options": [
        "By registering with Zookeeper directly on startup",
        "By writing their status to the __consumer_status topic",
        "By sending heartbeats to the group coordinator broker",
        "By polling the controller broker for group membership"
      ],
      "answer": 2,
      "explanation": "Consumers maintain membership by sending heartbeats to a Kafka broker designated as the group coordinator. As long as heartbeats are sent at regular intervals, the consumer is assumed alive. If heartbeats stop, the group coordinator considers the consumer dead and triggers a rebalance."
    },
    {
      "q": "What is a partition rebalance?",
      "options": [
        "Redistributing data evenly across partitions when a partition becomes too large",
        "Moving partition ownership from one consumer to another within a consumer group",
        "Replicating partition data to additional brokers for fault tolerance",
        "Reordering messages within a partition to fix out-of-order delivery"
      ],
      "answer": 1,
      "explanation": "A rebalance is the reassignment of partition ownership among consumers in a group. It happens when a consumer joins or leaves the group, or when new partitions are added to a topic. During a rebalance, consumers cannot consume messages — it is a short window of unavailability for the entire group."
    },
    {
      "q": "If two applications need to read ALL messages from the same Kafka topic, what should you do?",
      "options": [
        "Put both applications'' consumers in the same consumer group",
        "Create a separate copy of the topic for each application",
        "Give each application its own consumer group",
        "Use one consumer group and set enable.auto.commit to false"
      ],
      "answer": 2,
      "explanation": "Each consumer group gets all messages from the subscribed topics independently. To ensure each application reads all messages, assign each application its own consumer group. Consumers within the same group split messages between them — they each get only a subset."
    },
    {
      "q": "If the committed offset is smaller than the offset of the last message a consumer processed, what happens during a rebalance?",
      "options": [
        "The missed messages are permanently lost",
        "Messages between the committed offset and the last processed offset will be processed twice (duplicates)",
        "The consumer resumes from the last processed offset automatically",
        "Kafka replays the entire partition from the beginning"
      ],
      "answer": 1,
      "explanation": "After a rebalance, the new consumer picks up from the last committed offset. If that offset is behind what was actually processed, the messages in between will be reprocessed, causing duplicates. This is one of the key tradeoffs in offset management (Figure 4-6 in the book)."
    },
    {
      "q": "What is the key difference between commitSync() and commitAsync()?",
      "options": [
        "commitSync() commits to the leader, commitAsync() commits to all replicas",
        "commitSync() blocks until the broker responds and retries on failure; commitAsync() returns immediately and does not retry",
        "commitSync() commits the earliest offset, commitAsync() commits the latest",
        "There is no practical difference — they are aliases for the same operation"
      ],
      "answer": 1,
      "explanation": "commitSync() blocks the application until the broker responds and will retry on failure until it succeeds or hits an unrecoverable error. commitAsync() sends the request and continues immediately. It does not retry because by the time a retry would happen, a later offset may have already been committed, and retrying an old offset could cause problems."
    },
    {
      "q": "Why does the book recommend combining commitAsync() with commitSync() at shutdown?",
      "options": [
        "commitAsync() is faster so it should be used first to save time",
        "commitAsync() handles the normal case efficiently, while commitSync() at shutdown ensures the final offset is committed before the consumer leaves the group",
        "They commit to different internal topics and both are needed for consistency",
        "commitSync() only works during shutdown — it throws an error during normal operation"
      ],
      "answer": 1,
      "explanation": "During normal processing, occasional commit failures from commitAsync() are acceptable because the next commit will succeed. But at shutdown, there is no ''next commit'' — so you use commitSync() in the finally block to retry until the last offset is reliably committed before the consumer leaves the group."
    },
    {
      "q": "Why does the book recommend using Avro and the Schema Registry for deserialization instead of custom deserializers?",
      "options": [
        "Custom deserializers are not supported by the KafkaConsumer API",
        "Avro is the only format that supports null values in messages",
        "Custom deserializers tightly couple producers and consumers and are fragile to schema changes; Avro with Schema Registry ensures compatibility automatically",
        "The Schema Registry is required by Kafka for all production deployments"
      ],
      "answer": 2,
      "explanation": "Custom serializers/deserializers require both the producer and consumer to share the same class implementation and tightly couple them. If the schema changes (e.g., adding a field), maintaining compatibility becomes very challenging. Avro with the Schema Registry ensures that data written with one schema version can be read with a compatible version, catching errors early instead of requiring manual byte-array debugging."
    },
    {
      "q": "When would you use a standalone consumer with assign() instead of subscribe() with a consumer group?",
      "options": [
        "When you need to consume from more than one topic at a time",
        "When you always need to read from all partitions (or specific partitions) of a topic and don''t need group-based rebalancing",
        "When you want automatic failover if the consumer crashes",
        "When you need exactly-once delivery guarantees"
      ],
      "answer": 1,
      "explanation": "A standalone consumer uses assign() to self-assign specific partitions instead of relying on group coordination. This is useful when you know exactly which partitions to read and don''t need the automatic rebalancing that consumer groups provide. Note that a consumer can either subscribe to topics (group) or assign partitions (standalone), but not both."
    },
    {
      "q": "What does the auto.offset.reset configuration control?",
      "options": [
        "How often offsets are automatically committed to Kafka",
        "Whether the consumer resets its offset to zero after each rebalance",
        "Where the consumer starts reading when it has no committed offset or the committed offset is invalid — either from the latest or earliest available message",
        "The maximum number of offsets the consumer can fall behind before being kicked from the group"
      ],
      "answer": 2,
      "explanation": "auto.offset.reset determines behavior when a consumer starts reading a partition with no valid committed offset. The default ''latest'' means it reads only new messages written after it started. The alternative ''earliest'' reads all data from the beginning of the partition. This is important for new consumer groups or when a consumer has been down long enough that its committed offset was aged out."
    }
  ]'::jsonb
);
