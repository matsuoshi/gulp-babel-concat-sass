gulp = require 'gulp'
browserSync = require 'browser-sync'
gulpLoadPlugins = require 'gulp-load-plugins';
$ = gulpLoadPlugins();


dir =
  styles:
    src : 'src/styles'
    dest: 'assets/css'
  scripts:
    src : 'src/scripts'
    dest: 'assets/js'


gulp.task 'scripts', ->
  gulp.src ["#{dir.scripts.src}/lib/**/*.js", "#{dir.scripts.src}/*.js"]
  .pipe $.plumber()
  .pipe $.sourcemaps.init
    loadMaps: true
  .pipe $.concat 'scripts.js'
  .pipe $.babel()
  .pipe $.uglify
    preserveComments: 'license'
  .pipe $.sourcemaps.write('.')
  .pipe gulp.dest dir.scripts.dest


gulp.task 'styles', ->
  gulp.src "#{dir.styles.src}/**/*.scss"
    .pipe $.plumber()
    .pipe $.sourcemaps.init()
    .pipe $.sass(
      includePaths: ['.']
      outputStyle : 'compressed'
    ).on('error', $.sass.logError)
    .pipe $.autoprefixer()
    .pipe $.sourcemaps.write('.')
    .pipe gulp.dest dir.styles.dest


gulp.task 'build', ['scripts', 'styles']


gulp.task 'watch', ->
  gulp.watch "#{dir.scripts.src}/**/*.js", ['scripts']
  gulp.watch "#{dir.styles.src}/**/*.scss", ['styles']


gulp.task 'serve', ['watch'], ->
  browserSync
    notify: false
    port: 9000,
    files: [
      '**/*.html'
      '**/*.php'
      "#{dir.styles.dest}/**/*.css"
      "#{dir.scripts.dest}/**/*.js"
    ]


gulp.task 'default', ['build', 'serve']
