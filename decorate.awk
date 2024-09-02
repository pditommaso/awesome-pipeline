# to prepare README with meta data run the following line
# awk -f  decorate.awk README.md  > README_meta.md
# If interested in checking the sites for being up or down, run the following line
# awk -f  decorate.awk -v CHECK=1 README.md  > README_meta.md

!/^\* \[/ { 
  print    # just print the line if not an item line
} 
/^\* \[/ {
  split($0,text," - ")  # text[2] is desc
  length(text[2]) > 2  ? description=" - "text[2] : description=""         # if there's no dash, then dont print dash
  split(text[1],markd,/[\(\)\[\]]/)  # get name and url from markdown 2:name 4:url
  MESG=""
if (CHECK==1){
    RESPONSE=system("curl --output /dev/null --silent --head --fail " markd[4])  # let's check is site is up
    print NR,SITE,markd[4] > "/dev/stderr"
    (RESPONSE==22) ? MESG=" *(Site is down)*" : MESG=""                    # if 404, then prepare response text
    (RESPONSE==7) ? MESG=" *(Site does not exist)*" : MESG=""                    # if 404, then prepare response text
    (RESPONSE==28) ? MESG=" *(Site time outs)*" : MESG=""                    # if 404, then prepare response text

  }
  split(markd[4],meta,/\//)          #3:domain,4:username,5:repo
  if(meta[3]!="github.com"){
    printf"%s%s%s\n", text[1],description,MESG
  } else {
    printf"* [%s](https://github.com/%s/%s) ![lang](https://img.shields.io/github/languages/top/%s/%s?color=456eb0) ![stars](https://img.shields.io/github/stars/%s/%s?color=b0446d) ![activity](https://img.shields.io/github/last-commit/%s/%s?color=6eb045)%s\n", markd[2],meta[4],meta[5],meta[4],meta[5],meta[4],meta[5], meta[4],meta[5],description
  }
}
