'use strict';

const {spawnSync} = require('child_process');
const replace = require('replace-in-file');
const YAML = require('yaml');

// standard-version-updater.js
const regexPuspecVersion = new RegExp(['(^version:\\s+)((0|[1-9]\\d*)\\.(0|[1-',
  '9]\\d*)\\.(0|[1-9]\\d*)(?:-((?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\\',
  '.(?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\\+([0-9a-zA-Z-]+(?:\\.[',
  '0-9a-zA-Z-]+)*))?)(?=$)'].join(''), 'gm');

module.exports.readVersion = function(contents) {
  const pubspec = YAML.parse(contents);

  return pubspec.version;
};

module.exports.writeVersion = function(contents, version) {
  const pubspec = YAML.parse(contents);
  const legytmaVersion = pubspec.legytma_schema.version;
  const replaceOptions = {
    files: [
      'lib/**/*',
      'example/**/*',
      'test/**/*',
      '*.md',
    ],

    // Replacement to make (string or regex)
    from: new RegExp(['((https:\\/\\/legytma\\.com\\.br\\/(?=schema\\/))|(http',
      's:\\/\\/schema\\.legytma\\.com\\.br\\/((0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\.',
      '(0|[1-9]\\d*)(?:-((?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\\.(?:0|',
      '[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\\+([0-9a-zA-Z-]+(?:\\.[0-',
      '9a-zA-Z-]+)*))?)\\/))'].join(''), 'gm'),
    to: `https://schema.legytma.com.br/${legytmaVersion}/`,
    countMatches: true,
  };

  try {
    const results = replace.sync(replaceOptions);

    // console.log('Replacement results:', results);

    results.forEach((result) => {
      if (result.hasChanged) {
        const addCommandResponse = spawnSync('git', ['add', '-v', result.file],
            {maxBuffer: 10000000});

        showCommandResult(addCommandResponse);
      }
    });
  } catch (error) {
    console.error('Error occurred:', error);
  }

  return contents.replace(regexPuspecVersion, `$1${version}`);
};

/**
 * Extern script result to console.
 *
 * @param {object} command - sawnSync result.
 */
function showCommandResult(command) {
  if (command.output) {
    console.log(command.output.toString());
  }

  if (command.stderr) {
    console.error(command.stderr.toString());
  }

  if (command.error) {
    console.error(command.error);
  }
}
