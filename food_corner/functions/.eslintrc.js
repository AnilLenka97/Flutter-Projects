module.exports = {
  root: true,
  env: {
    es6: true,
    node: true,
  },
  extends: [
    'eslint:recommended',
    'google',
  ],
  rules: {
    // quote: ['error', 'double'],
    'max-len': ['error', {'code': 180}],
    'require-jsdoc': 0,
  },
};
