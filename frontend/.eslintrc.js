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
    'ember-suave/no-direct-property-access': 'off',
    'ember-suave/require-access-in-comments': 'off',
    'ember-suave/prefer-destructuring': ['error', { 'array': false }] // array suggests pointlessly replacing foo[0]
  }
};
