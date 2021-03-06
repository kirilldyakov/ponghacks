gulp        = require "gulp"
jshint      = require "gulp-jshint"
livereload  = require "gulp-livereload"
nodemon     = require "gulp-nodemon"
fs          = require "fs"
stylus      = require "gulp-stylus"
watch       = require "gulp-watch"

require "colors"

# --- TODO: ---------------------------
# uglify    = require "gulp-uglify"
# concat    = require "gulp-concat"
# beautify  = require "gulp-js-beautify"
# concat    = require "gulp-concat"
# rename    = require "gulp-rename"
# uglify    = require "gulp-uglify"
# filter    = require "gulp-filter"
minifyCSS = require "gulp-minify-css"


jsFiles = ["./client/**/*.js", "./server/**/*.js", "./scripts/updateUsers.js"]
stylusFiles = ["./client/stylus/**/*.styl"]
stylusMain = ["./client/stylus/main.styl"]

# jsDist = "./client/public/assets/js/"
cssDist = "./client/public/assets/css/"
cssFiles = cssDist + "*.css"


htmlFiles = "./client/public/views/**/*.html"



## --- JavaScript
## ------------------
gulp.task "scripts", ->
  console.log "Linting".underline.cyan, "JS".black.bgYellow
  gulp.src jsFiles
    .pipe jshint() 
    .pipe jshint.reporter "default"
    .pipe jshint.reporter "fail"
    .pipe livereload()



## --- Stylesheets
## ------------------
gulp.task "stylesheets", ->
  console.log "Compiling".underline.cyan, "Stylus".bgGreen
  gulp.src stylusMain
    .pipe stylus()
    .pipe gulp.dest cssDist
    .pipe livereload()


gulp.task "minify", ->
  gulp.src cssFiles
    .pipe minifyCSS()
    .pipe gulp.dest cssDist

gulp.task "html", ->
  gulp.src htmlFiles
    .pipe livereload()



## --- Server
## ------------------
gulp.task "server", ->
  
  livereload.listen()

  options = 
    script: "server/server.js"
    ext: "js"
    watch: "server/**/*.js"

  nodemon options
    .on "start", ->
      console.log "--------".america, "STARTED NODEMON!".green, "--------".america
    .on "restart", ->
      console.log "--------".america, "RESTARTED NODEMON!".green, "--------".america



## --- Watch
## ------------------
gulp.task "watch", ->
  
  console.log "Watching".underline.cyan, "Stylus".bgGreen
  gulp.watch stylusFiles, ["stylesheets"]
  
  console.log "Watching".underline.cyan, "JS".black.bgYellow
  gulp.watch jsFiles, ["scripts"]

  console.log "Watching".underline.cyan, "HTML".black.bgYellow
  gulp.watch htmlFiles, ["html"]



## ------------------
## ----  TASKS  -----
## ------------------

gulp.task "default", ["scripts", "stylesheets", "server", "watch"]

