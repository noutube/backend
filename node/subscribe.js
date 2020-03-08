const { hrtime } = require('process');
const querystring = require('querystring');

const axios = require('axios');
const { Client } = require('pg');
const throat = require('throat');

const RAILS_ENV = process.env.RAILS_ENV || 'development';
const POSTGRESQL_DATABASE = process.env.POSTGRESQL_DATABASE || `nou2ube_db_${RAILS_ENV}`;
const RAILS_ORIGIN = RAILS_ENV === 'production' ? 'https://api.noutu.be' : 'http://localhost:9292';
const CONCURRENCY = 5;

const elapsed = (start) => {
  const [seconds, nanoseconds] = hrtime(start);
  return seconds + nanoseconds / 1_000_000_000;
};

const getChannels = async () => {
  const client = new Client({ database: POSTGRESQL_DATABASE });
  await client.connect();
  const { rows } = await client.query('SELECT id, api_id, title, secret_key FROM channels');
  await client.end();
  return rows;
};

const subscribeChannel = async ({ id, api_id, title, secret_key }) => {
  const start = hrtime();
  try {
    await axios.post('https://pubsubhubbub.appspot.com/subscribe', querystring.stringify({
      'hub.callback': `${RAILS_ORIGIN}/push/${api_id}`,
      'hub.topic': `https://www.youtube.com/xml/feeds/videos.xml?channel_id=${api_id}`,
      'hub.mode': 'subscribe',
      'hub.secret': secret_key,
      'hub.verify': 'async'
    }));
  } catch (error) {
    console.error(`${title} (${id}) error:`, error);
  } finally {
    return elapsed(start);
  }
};

const sum = (values) => values.reduce((acc, curr) => acc + curr, 0);
const mean = (values) => sum(values) / values.length;
const min = (values) => values.reduce((acc, curr) => Math.min(acc, curr), Number.POSITIVE_INFINITY);
const max = (values) => values.reduce((acc, curr) => Math.max(acc, curr), Number.NEGATIVE_INFINITY);

const main = async () => {
  const channels = await getChannels();

  console.log('channels', channels.length);
  console.log('concurrency', CONCURRENCY);

  const start = hrtime();
  const times = await Promise.all(channels.map(throat(CONCURRENCY, subscribeChannel)));
  const overall = elapsed(start);

  console.log('overall', overall);
  console.log('sum', sum(times));
  console.log('mean', mean(times));
  console.log('min', min(times));
  console.log('max', max(times));
};

main();
