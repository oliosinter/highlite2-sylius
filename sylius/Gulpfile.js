var gulp = require('gulp');
var chug = require('gulp-chug');
var argv = require('yargs').argv;
var rev = require('gulp-rev');
var revdel = require('gulp-rev-delete-original');

config = [
    '--rootPath',
    argv.rootPath || '../../../../../../../web/assets/',
    '--nodeModulesPath',
    argv.nodeModulesPath || '../../../../../../../node_modules/'
];

gulp.task('admin', function () {
    gulp.src('vendor/sylius/sylius/src/Sylius/Bundle/AdminBundle/Gulpfile.js', {read: false})
        .pipe(chug({args: config}))
    ;
});

gulp.task('shop', function () {
    process.env.NODE_ENV = 'prod';
    gulp.src('vendor/sylius/sylius/src/Sylius/Bundle/ShopBundle/Gulpfile.js')
        .pipe(chug({args: config}))
    ;
});

gulp.task('rev', function () {
    gulp.src(['web/assets/shop/**/*.js', 'web/assets/shop/**/*.css'], {base: 'web'})
        .pipe(rev())
        .pipe(revdel())
        .pipe(gulp.dest('web'))
        .pipe(rev.manifest('app/rev-manifest.json'))
        .pipe(gulp.dest('.'))
    ;
});

gulp.task('default', ['admin', 'shop']);
