module.exports = {
  root: true,
  parserOptions: {
    ecmaVersion: 2017,
    sourceType: 'module'
  },
  plugins: [
    'ember',
    'ember-suave'
  ],
  extends: [
    'eslint:recommended',
    'plugin:ember/recommended',
    'plugin:ember-suave/recommended'
  ],
  env: {
    browser: true
  },
  rules: {
    'no-unused-vars': ['error', { args: 'none' }], // ignore arguments since we can't mark unused with underscores
    'semi': ['error', 'always'],
    'indent': ['error', 2, { SwitchCase: 1 }],
    'camelcase': 'off', // we need camelcase for API interaction
    'no-console': 'off', // see https://github.com/emberjs/rfcs/pull/176#issuecomment-272566327
    'ember/named-functions-in-promises': ['error', { allowSimpleArrowFunction: true, }],
    'ember/no-observers': 'off'
  },
  overrides: [
    // node files
    {
      files: [
        'testem.js',
        'ember-cli-build.js',
        'config/**/*.js',
        'lib/*/index.js',
      ],
      parserOptions: {
        sourceType: 'script',
        ecmaVersion: 2015
      },
      env: {
        browser: false,
        node: true
      }
    }
  ]
};
