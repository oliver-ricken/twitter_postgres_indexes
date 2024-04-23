SELECT 
    tag, 
    count(*) AS count
FROM (
    SELECT DISTINCT
        data->>'id' AS id_tweets, 
        '#' || (jsonb_array_elements(data->'entities'->'hashtags' || coalesce(data->'extended_tweet'->'entities'->'hashtags','[]'))->>'text') as tag
    FROM tweets_jsonb
    WHERE to_tsvector('english', COALESCE(data->'extended_tweet'->>'full_text',data->>'text'))@@to_tsquery('english','coronavirus')
      AND data->>'lang'='en'
) tg
GROUP BY tag
ORDER BY count DESC, tag
LIMIT 1000;
