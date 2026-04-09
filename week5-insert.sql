-- Week 5 Quiz: Chapter 11 - Stream Processing
-- Run this in Supabase SQL Editor (Dashboard > SQL Editor)

INSERT INTO quizzes (week_number, title, description, questions)
VALUES (
  5,
  'Chapter 11: Stream Processing',
  'Stream Processing - Test your knowledge of unbounded datasets, event time vs. processing time, state management, time windows, stream-table duality, design patterns, Kafka Streams architecture, and exactly-once semantics.',
  '[
    {
      "q": "According to the text, what is the primary characteristic of an \"unbounded dataset\" in the context of stream processing?",
      "options": [
        "It is strictly unordered and easily modifiable.",
        "It is infinite and ever-growing because new records keep arriving over time.",
        "It is limited only by the amount of local memory available.",
        "It only stores data for a predefined 24-hour window."
      ],
      "answer": 1,
      "explanation": "An unbounded dataset is one that is infinite and ever-growing — new records continuously arrive over time, meaning the dataset has no defined end. This is the fundamental distinction from a bounded (batch) dataset, which has a known beginning and end. Stream processing systems are designed specifically to handle this continuous flow of data."
    },
    {
      "q": "Which notion of time refers to the actual moment an action occurred (e.g., a measurement was taken or an item was sold)?",
      "options": [
        "Log append time",
        "Processing time",
        "Event time",
        "Ingestion time"
      ],
      "answer": 2,
      "explanation": "Event time is the time when the event actually occurred at the source — for example, the timestamp when a measurement was taken, a user clicked a button, or an item was sold. This is distinct from processing time (when the stream processing application receives and processes the event) and log append time (when the event was stored in a broker). Event time is critical for accurate windowing and out-of-order event handling."
    },
    {
      "q": "Why is storing state in standard, local application variables (like a simple hash table) considered unreliable for stream processing?",
      "options": [
        "It requires too much CPU overhead.",
        "It cannot be queried using SQL.",
        "It causes infinite loops in the processing topology.",
        "The state is permanently lost if the application stops or crashes."
      ],
      "answer": 3,
      "explanation": "If state is stored only in local application memory (e.g., a simple HashMap), it is permanently lost when the application crashes, restarts, or is redeployed. Stream processing frameworks solve this by persisting state to durable, fault-tolerant stores (like RocksDB backed by Kafka changelog topics) so that state can be recovered after failures without data loss."
    },
    {
      "q": "When discussing time windows, what do you call a window where the advance interval is exactly equal to the window size?",
      "options": [
        "Hopping window",
        "Tumbling window",
        "Session window",
        "Sliding window"
      ],
      "answer": 1,
      "explanation": "A tumbling window is a special case of a hopping window where the advance interval (or ''hop'') equals the window size. This means windows never overlap — each event belongs to exactly one window. For example, a 5-minute tumbling window creates non-overlapping buckets: 0:00–0:05, 0:05–0:10, 0:10–0:15, etc. In contrast, a hopping window with a smaller advance interval creates overlapping windows."
    },
    {
      "q": "Converting a stream of change events into a current-state table is a process commonly referred to as what?",
      "options": [
        "Materializing the stream",
        "Repartitioning the table",
        "Compacting the log",
        "Beaconing"
      ],
      "answer": 0,
      "explanation": "Materializing a stream means replaying the stream of change events and building a table that represents the current state at any point in time. Each new event updates the corresponding entry in the table (insert, update, or delete). This is the core of the stream-table duality: a table is a materialized view of a stream, and a stream is a changelog of a table."
    },
    {
      "q": "Performing an external database lookup for every event adds significant latency. Which design pattern solves this by keeping a fast, local copy of the data updated via event streams?",
      "options": [
        "Map/filter pattern",
        "Multiphase processing / Repartitioning",
        "Stream-table join utilizing Change Data Capture (CDC)",
        "Windowed stream-to-stream join"
      ],
      "answer": 2,
      "explanation": "A stream-table join using Change Data Capture (CDC) avoids the latency of external database lookups by capturing database changes as a stream of events and materializing them into a local table (state store). When an event arrives that needs enrichment, the application can perform a fast local lookup against this CDC-populated table instead of making a remote call, dramatically reducing latency while keeping the data up to date."
    },
    {
      "q": "In Kafka Streams, what is the basic unit of parallelism that executes independently and scales based on the number of topic partitions?",
      "options": [
        "A task",
        "A thread",
        "A topology",
        "A KTable"
      ],
      "answer": 0,
      "explanation": "In Kafka Streams, a task is the basic unit of parallelism. Each task is responsible for processing data from a subset of the input partitions. The number of tasks is determined by the number of partitions in the input topics. Tasks execute independently and can be distributed across threads and application instances, enabling horizontal scaling."
    },
    {
      "q": "To ensure faster recovery when a processing node fails, what mechanism can keep the current state \"warm\" on a different server so it is ready to take over with minimal downtime?",
      "options": [
        "Foreign-key joins",
        "Global state stores",
        "Standby replicas",
        "TopologyTestDriver"
      ],
      "answer": 2,
      "explanation": "Standby replicas maintain a copy of the local state store on a different application instance. They continuously replay the changelog topic to keep the replica up to date. When a node fails, instead of rebuilding the entire state from scratch (which could take a long time for large state stores), a standby replica can take over almost immediately because its state is already ''warm'' and nearly current."
    },
    {
      "q": "Which testing tool does the text recommend for writing fast, lightweight unit tests for Kafka Streams topologies without needing to spin up Docker containers or real brokers?",
      "options": [
        "EmbeddedKafkaCluster",
        "Testcontainers",
        "StreamsBuilder",
        "TopologyTestDriver"
      ],
      "answer": 3,
      "explanation": "The TopologyTestDriver is a testing utility provided by Kafka Streams that allows you to test your processing topology in-memory without requiring a running Kafka cluster, Docker containers, or embedded brokers. It simulates the behavior of the Kafka Streams engine, letting you pipe input records through the topology and verify output records, making tests fast, deterministic, and easy to write."
    },
    {
      "q": "How do you enable exactly-once processing guarantees in a Kafka Streams application?",
      "options": [
        "By setting processing.guarantee to exactly_once or exactly_once_beta",
        "By ensuring all events share the exact same timestamp",
        "By disabling local state stores to prevent data duplication",
        "By setting the consumer advance interval to 0"
      ],
      "answer": 0,
      "explanation": "Exactly-once semantics in Kafka Streams is enabled by setting the processing.guarantee configuration to exactly_once (or exactly_once_beta / exactly_once_v2 in newer versions). This leverages Kafka''s transactional capabilities to ensure that for each input record, the resulting state updates, output records, and offset commits are all performed atomically — meaning records are processed exactly once, even in the face of failures and retries."
    }
  ]'::jsonb
);
