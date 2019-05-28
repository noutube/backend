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
    'keyword-spacing': ['error', { 'overrides': { 'catch': { 'after': true } } }]
  },
  overrides: [
    // node files
    {
      files: [
        '.eslintrc.js',
        '.template-lintrc.js',
        'testem.js',
        'ember-cli-build.js',
        'config/**/*.js',
        'lib/*/index.js',
        'server/**/*.js'
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
