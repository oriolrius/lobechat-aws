module.exports = {
  extends: ['@commitlint/config-conventional'],
  rules: {
    'type-enum': [
      2,
      'always',
      [
        'feat',     // New feature
        'fix',      // Bug fix
        'docs',     // Documentation
        'style',    // Formatting, no code change
        'refactor', // Code change, no new feature or bug fix
        'perf',     // Performance improvement
        'test',     // Adding tests
        'build',    // Build system or dependencies
        'ci',       // CI configuration
        'chore',    // Other changes
        'revert',   // Revert previous commit
      ],
    ],
    'subject-case': [0],  // Disable case check
  },
};
