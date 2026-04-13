import { exec } from 'child_process';
import os from 'os';
import path from 'path';

const LMStudioGuardPlugin = async (ctx) => {
  const homeDir = os.homedir();
  const lmsPath = path.join(homeDir, '.lmstudio/bin/lms');

  console.log(`\x1b[34m[LM Studio Guard]\x1b[0m Checking LM Studio server status...`);

  exec(`"${lmsPath}" status`, (error, stdout, stderr) => {
    if (stdout && stdout.includes('ON')) {
      console.log(`\x1b[32m[LM Studio Guard]\x1b[0m Server is already running.`);
    } else {
      console.log(`\x1b[33m[LM Studio Guard]\x1b[0m Server is off. Starting LM Studio server...`);
      exec(`"${lmsPath}" server start`, (startError, startStdout, startStderr) => {
        if (startError) {
          console.error(`\x1b[31m[LM Studio Guard] Failed to start server:\x1b[0m ${startError.message}`);
        } else {
          console.log(`\x1b[32m[LM Studio Guard]\x1b[0m Server started successfully.`);
        }
      });
    }
  });

  return {
    name: "opencode-lmstudio-guard",
  };
};

export default LMStudioGuardPlugin;