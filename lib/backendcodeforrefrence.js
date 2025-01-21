// ## user routes
// const express = require('express')
// const router = express.Router()
// const User = require('./../models/users')
// const { jwtAuthMiddleware, jwtgeneratetoken } = require('./../jwt')
// router.post('/signup', async (req, res) => {
//     try {
//         data = req.body
//         newperson = new User(data)
//         if (newperson.role == 'admin') {
//             const adminexist = await User.findOne({ role: 'admin' })
//             if (adminexist) {
//                 return res.status(401).json({ message: 'Admin already exist' });
//             }
//         }
//         result = await newperson.save()
//         payload = {
//             id: result.id,
//         }
//         jwttoken = jwtgeneratetoken(payload)
//         return res.status(201).json({ message: 'Person saved successfully', data: result, token: jwttoken });
//     } catch (error) {
//         return res.status(500).json({ message: 'Error saving person', error: error.message });
//     }
// })

// router.post('/login', async (req, res) => {
//     try {
//         const { aadhar, password } = req.body
//         prsn = await User.findOne({ aadhar: aadhar })
//         if (!prsn) {
//             return res.status(401).json({ message: 'Invalid aadhar', error: error.message });
//         }
//         pass = await prsn.comparePassword(password)
//         if (pass) {
//             payload = {
//                 id: prsn.id,
//             }
//             jwttoken = jwtgeneratetoken(payload)
//             return res.status(201).json({ token: jwttoken });
//         }
//         else {
//             return res.status(401).json({ message: 'Invalid password', error: error.message });
//         }

//     } catch (err) {
//         res.status(500).json({ message: "Internal server error", error: err })
//     }

// })

// router.get('/profile', jwtAuthMiddleware, async (req, res) => {
//     try {
//         userdata = req.user
//         const data = await User.findById(userdata.id)
//         console.log('person fetch successful')
//         return res.status(200).json(data)

//     } catch (error) {
//         console.log('person fetch unsuccessful')
//         return res.status(500).json('Internal Server Error')
//     }
// })

// router.put('/profile/password', jwtAuthMiddleware, async (req, res) => {
//     try {
//         userid = req.user.id
//         const { currpass, newpass } = req.body
//         user = await User.findById(userid)
//         pass = await user.comparePassword(currpass)
//         if (!pass) {
//             return res.status(401).json({ message: 'Invalid password', error: error.message });
//         }
//         user.password = newpass
//         await user.save()
//         res.status(201).json({ responsemsg: "Password updated" });
//     } catch (error) {
//         res.status(500).json({ message: 'Error saving person', error: error.message });
//     }
// })
// module.exports = router

// ## candidate routes
// const express = require('express')
// const router = express.Router()

// const Candidate = require('./../models/candidate')
// const User = require('./../models/users')
// const { jwtAuthMiddleware, jwtgeneratetoken } = require('../jwt')
// const { count } = require('console')
// checkadmin = async (userid) => {
//     try {
//         const userr = await User.findById(userid)
//         return userr.role == 'admin'
//     } catch (error) {
//         console.log(error.message)
//         return false
//     }

// }
// router.post('/', jwtAuthMiddleware, async (req, res) => {
//     try {
//         if (await !checkadmin(req.user.id)) {
//             return res.status(403).json({ message: 'Wrong Address' })
//         }
//         data = req.body
//         newcandidate = new Candidate(data)
//         result = await newcandidate.save()
//         return res.status(201).json({ message: 'Candidate saved successfully', data: result, token: jwttoken });
//     } catch (error) {
//         return res.status(500).json({ message: 'Error saving candidate', error: error.message });
//     }
// })


// router.put('/:candidateid', jwtAuthMiddleware, async (req, res) => {
//     try {
//         if (!checkadmin(req.user.id)) {
//             return res.status(403).json({ message: 'Wrong Address, Admin only area' })
//         }
//         data = req.body
//         givenid = req.params.candidateid
//         responsemsg = await Candidate.findByIdAndUpdate(givenid, data, {
//             newvalidator: true,
//             new: true

//         })
//         if (!responsemsg) {
//             return res.status(201).json('candidate not found')
//         }
//         else {
//             return res.status(201).json({ responsemsg });
//         }
//     } catch (error) {
//         res.status(500).json({ message: 'Error saving candidate', error: error.message });
//     }
// })
// router.delete('/:candidateid', jwtAuthMiddleware, async (req, res) => {
//     try {
//         if (!checkadmin(req.user.id)) {
//             return res.status(403).json({ message: 'Wrong Address, Admin only area' })
//         }
//         givenid = req.params.candidateid
//         responsemsg = await Candidate.findByIdAndDelete(givenid)
//         if (!responsemsg) {
//             return res.status(201).json('candidate not found')
//         }
//         else {
//             return res.status(201).json('candidate deleted successfully');
//         }
//     } catch (error) {
//         return res.status(500).json({ message: 'Error saving candidate', error: error.message });
//     }
// })
// router.put('vote/:candidateid', jwtAuthMiddleware, async (req, res) => {
//     try {
//         if (checkadmin(req.user.id)) {
//             return res.status(403).json({ message: 'Admin cannot vote' })
//         }
//         const userid = req.user.id
//         user = await User.findById(userid)
//         const givenid = req.params.candidateid
//         candidate = await Candidate.findById(givenid)
//         if (!candidate) {
//             return res.status(201).json('candidate not found')
//         }
//         if (!user) {
//             return res.status(201).json('user not found')
//         }
//         if (user.isvoted) {
//             return res.status(201).json('user not found')
//         }
//         user.isvoted = true
//         await user.save()
//         candidate.votecount++
//         candidate.votes.push({ user: userid })
//         await candidate.save()
//         return res.status(201).json({ responsemsg: 'Voted Successfully' });

//     } catch (error) {
//         res.status(500).json({ message: 'Error saving candidate', error: error.message });
//     }
//     router.get('/vote/count', async (req, res) => {
//         try {
//             candidates = await Candidate.find().sort({ votecount: 'desc' })
//             datas = candidate.map((data) => {
//                 return {
//                     party: data.party,
//                     count: data.votecount
//                 }
//             })
//             return res.status(201).json(datas);
//         } catch (error) {
//             res.status(500).json({ message: 'Error saving candidate', error: error.message });

//         }
//     })
//     router.get('/', async (req, res) => {
//         try {
//             ## Find all candidates and select only the name and party fields, excluding _id
//             const candidates = await Candidate.find({}, 'name party -_id');

//             ## Return the list of candidates
//             res.status(200).json(candidates);
//         } catch (err) {
//             console.error(err);
//             res.status(500).json({ error: 'Internal Server Error' });
//         }
//     });
// })
// module.exports = router

// ## server.js
// const express = require('express')
// const app = express()
// const db = require('./db')
// require('dotenv').config()
// const bodyparser = require('body-parser')
// app.use(bodyparser.json())
// const { jwtAuthMiddleware, jwtgeneratetoken } = require('./jwt')

// userroute = require('./routes/userRoutes')
// candidateroute = require('./routes/candidateRoutes')

// app.use('/user', userroute)
// app.use('/candidate', jwtAuthMiddleware, candidateroute)

// port = process.env.Port || 3000
// app.listen(port, () => {
//     console.log('listening to port number ', port)
// })
// ## jwt code
// const jwt = require("jsonwebtoken")
// ## require('dotenv').config()
// jwtAuthMiddleware = (req, res, next) => {
//     try {
//         const authorization = req.headers.authorization
//         ## console.log(req.header, 'and', req.header.Authorization)
//         if (!authorization) { return res.status(401).json({ message: 'token not found' }) }
//         const token = authorization.split(' ')[1]
//         console.log(token)
//         const user = jwt.verify(token, process.env.secretkey)
//         if (!user) {
//             return res.status(401).json({ message: 'Invalid token' })
//         }
//         else {
//             req.user = user
//             next()
//         }
//     } catch (error) {
//         console.log('error in jwtmiddleware')
//         res.status(401).json({ message: 'Invalid token' })
//     }
// }
// jwtgeneratetoken = (userData) => {
//     token = jwt.sign(userData, process.env.secretkey)
//     return token
// }
// module.exports = { jwtAuthMiddleware, jwtgeneratetoken }
// ## user model
// const mongoose = require('mongoose');
// const bcrypt = require('bcrypt')

// const Userschema = new mongoose.Schema({
//     name: {
//         type: String,
//         required: true
//     },
//     email: {
//         type: String,

//     },
//     phone: {
//         type: Number,

//     },
//     age: {
//         type: Number,
//         required: true,
//         min: 0 ## Age should be non-negative
//     },
//     address: {
//         type: String,
//         required: true
//     },
//     aadhar: {
//         type: Number,
//         unique: true,
//         required: true
//     },
//     password: {
//         type: String,
//         required: true
//     },
//     role: {
//         type: String,
//         enum: ['voter', 'admin'],
//         default: 'voter'
//     },
//     isVoted: {
//         type: Boolean,
//         default: false
//     }
// });
// Userschema.pre('save', async function (next) {
//     const person = this;
//     if (!person.isModified('password')) return next();
//     try {
//         const salt = await bcrypt.genSalt(10);
//         const hashedPassword = await bcrypt.hash(person.password, salt)
//         person.password = hashedPassword
//         next()
//     } catch (error) {
//         console.log(error)
//     }
// })
// Userschema.methods.comparePassword = async function (parampass) {
//     try {
//         const isMatch = await bcrypt.compare(parampass, this.password)
//         return isMatch
//     } catch (error) {
//         console.log("password didn't match", parampass, this.password)
//         return false;
//     }
// }
// ##chatgpt tell me should i use this below line or next line to it to create model
// User = mongoose.model('User', Userschema)

// module.exports = User
// ## candidate model
// const mongoose = require('mongoose');
// ## const bcrypt = require('bcrypt')
// const candidateschema = new mongoose.Schema({
//     name: {
//         type: String,
//         required: true
//     },
//     party: {
//         type: String,
//         required: true
//     },
//     age: {
//         type: Number,
//         required: true,
//         min: 0 ## Age should be non-negative
//     },
//     votes: [{

//         userid: {
//             type: mongoose.Schema.Types.ObjectId,
//             ref: 'User',
//             required: true
//         },
//         time: {
//             type: Date,
//             default: Date.now()

//         }
//     }],
//     votecount: {
//         type: Number,
//         default: 0
//     },
// });

// Candidate = mongoose.model('Candidate', candidateschema)
// module.exports = Candidate