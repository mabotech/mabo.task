## Not run: 
## Example: download the font file of WenQuanYi Micro Hei,
##          add it to SWF device, and use it to draw text in swf().
##          WenQuanYi Micro Hei is an open source and high quality
##          Chinese (and CJKV) font.

wd = setwd(tempdir())
ft.url = "http://sourceforge.net/projects/wqy/files/wqy-microhei"
ft.url = paste(ft.url, "0.2.0-beta/wqy-microhei-0.2.0-beta.tar.gz",
               sep = "/")
download.file(ft.url, basename(ft.url))

## Extract and add the directory to search path
untar(basename(ft.url), compressed = "gzip")
font.paths("wqy-microhei")

## Register this font file and assign the family name "wqy"
## Other font faces will be the same with regular by default
font.add("wqy", regular = "wqy-microhei.ttc")

## A more concise way to add font is to give the path directly,
## without calling font.paths()
# font.add("wqy", "wqy-microhei/wqy-microhei.ttc")

## List available font families
font.families()

if(require(R2SWF))
{
    ## Now it shows that we can use the family "wqy" in swf()
    swf("testfont.swf")

    ## Select font family globally
    op = par(family = "serif", font.lab = 2)
    ## Inline selecting font
    plot(1, type = "n")
    text(1, 1, intToUtf8(c(20013, 25991)), family = "wqy", font = 1, cex = 2)

    dev.off()
    swf2html("testfont.swf")
}

setwd(wd)


## End(Not run)