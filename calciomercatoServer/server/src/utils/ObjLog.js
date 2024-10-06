
let ObjLog = {};
// IF YOU WANT TO GET LOGS FROM DB SAVE THEM IN THIS VARIABLE
let logList = [];

ObjLog.log = async (msg) => {
  try {
    // await authenticationPGRepository.insertLogMsg(msg);
  } catch (error) {
    throw error;
  }
};

ObjLog.get = () => {
  return logList;
};

export default ObjLog