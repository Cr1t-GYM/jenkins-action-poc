import hudson.model.DownloadService;
println 'Downloading the plugins meta info...'
for (d in DownloadService.Downloadable.all()) {
    d.updateNow();
}
