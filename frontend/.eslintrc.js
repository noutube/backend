module.exports = {
  root: true,
  parserOptions: {
    ecmaVersion: 2017,
    sourceType: 'module'
  },
  extends: [
    'eslint:recommended',
    'plugin:ember-suave/recommended'
  ],
  env: {
    browser: true
  },
  rules: {
    'no-unused-vars': ['error', { 'args': 'none' }], // ignore arguments since we can't mark unused with underscores
    'semi': ['error', 'always'],
    'indent': ['error', 2, { 'SwitchCase': 1 }],
    'camelcase': 'off', // we need camelcase for API interaction
    'no-console': 'off' // see https://github.com/emberjs/rfcs/pull/176#issuecomment-272566327
  }
};
