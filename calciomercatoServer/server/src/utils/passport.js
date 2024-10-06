import passport from "passport";
import PassportLocal from "passport-local";
import logger  from "./logger.js";
import ObjLog from "./ObjLog.js";
import usersRepository from '../users/users.repository.js'
import encrypt from '../common/encrypt.js'

const LocalStrategy = PassportLocal.Strategy;
const context = "Authentication module";
let user;

const expressObj = {
  req: null,
  res: null,
  next: null,
  isAuthenticated: false,
  userExists: false,
};

// THIS SENDS A CUSTOM RESPONSE IF USER LOGS IN CORRECTLY
async function resp(user) {
  try {
    let sess = null;

    if (user == null){
      const log = {
        is_auth: expressObj.req.isAuthenticated(),
        success: false,
        failed: true,
        route: "/sign-in",
        session: sess,
      };
      expressObj.res.status(400).send(log);
    } else {
      expressObj.res.status(200).send({
        isAuthenticated: expressObj.isAuthenticated,
        user
      });
    }
  } catch (error) {
    expressObj.next(error);
  }
}

//PASSPORT AUTHENTICATION

passport.use(
  new LocalStrategy(
    {
      usernameField: "email",
      passwordField: "password",
      passReqToCallback: true,
    },
    async function (req, email, password, done) {
      try {
        // UPDATE IP IN BD
        expressObj.isAuthenticated = false;
        expressObj.userExists = false;

        logger.info(`[${context}]: Checking user`);
        ObjLog.log(`[${context}]: Checking user`);

        user = await usersRepository.readUserByEmail(email);

        if (user) {

          logger.info(`[${context}]: User found, checking password`);
          ObjLog.log(`[${context}]: User found, checking password`);

          const passwordsMatch = await encrypt.compare(password, user.password);

          if (passwordsMatch) {
            logger.info(`[${context}]: Successful login`);
              ObjLog.log(`[${context}]: Successful login`);

              expressObj.isAuthenticated = true;

              await resp(user);

              return done(null, user);
          } else {
            done(null, false);
            expressObj.req = req;
          }
        } else {
          logger.error(`[${context}]: User and password do not match`);
          ObjLog.log(`[${context}]: User and password do not match`);

          return done(null, false);
        }
      } catch (error) {
        done(error);
      }
    }
  )
);

passport.serializeUser(function (user, done) {
  // PASSPORT LOOKS FOR THE ID AND STORE IT IN SESSION
  console.log("serialize ", user.email);
  if (user) done(null, user.email)
});

passport.deserializeUser(async function (email, done) {
  try {
    // PASSPORT LOOKS FOR THE USER OBJECT WITH THE PREVIOUS username
    console.log("deserialize: ");

    const user = await usersRepository.readUserByEmail(email);

    done(null, user);
  } catch (error) {
    done(error);
  }
});

export default {
  verify: (req, res, next) => {
    try {
      expressObj.req = req;
      expressObj.res = res;
      expressObj.next = next;

      passport.authenticate("local", async function (err,user,info) {
        if (err) {
          return expressObj.next(err);
        }
        let response = null;
        if (!expressObj.isAuthenticated){
          expressObj.next()
        req.logIn(user, function(err) {
          if (err) {
            return next(err); }
        });

        }
        console.log("DENTRO DEL AUTHENTICATE");

        console.log("req.session despues de la strategy", req.session, user);
        // console.log("req.user despues de la strategy", req.user);
        expressObj.next();
        req.login(user, function(err) {
          if (err) {
            return next(err); }
        });
      }
      )(req, res, next);
    } catch (error) {
      expressObj.next(error);
    }
  },
};
