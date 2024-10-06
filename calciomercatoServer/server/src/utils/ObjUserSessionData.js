let ObjUserSessionData = {};
let objSess = {};

ObjUserSessionData.set = (obj) => {
  objSess = obj;
};

ObjUserSessionData.get = () => {
  return objSess;
};

export default ObjUserSessionData;
