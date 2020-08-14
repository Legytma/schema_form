const YAML = require('yaml');
const fs = require('fs');
const replace = require('replace-in-file');

const pubspecFile = fs.readFileSync('pubspec.yaml', 'utf8');

const pubspecContent = YAML.parse(pubspecFile);
const version = pubspecContent.legytma_schema.version;
const replaceOptions = {
  files: [
    'lib/**/*',
    'example/**/*',
    'test/**/*',
    '*.md',
  ],

  // Replacement to make (string or regex)
  from: new RegExp(['((https:\\/\\/legytma\\.com\\.br\\/(?=schema\\/))|(https:',
    '\\/\\/schema\\.legytma\\.com\\.br\\/((0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\.(0|[',
    '1-9]\\d*)(?:-((?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\\.(?:0|[1-9]',
    '\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\\+([0-9a-zA-Z-]+(?:\\.[0-9a-zA-Z',
    '-]+)*))?)\\/))'].join(''), 'gm'),
  to: `https://schema.legytma.com.br/${version}/`,
  countMatches: true,
};

try {
  const results = replace.sync(replaceOptions);

  console.log('Replacement results:', results);
} catch (error) {
  console.error('Error occurred:', error);
}
