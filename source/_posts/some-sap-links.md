---
title: some sap links
hide: true
tags: SAP
categories: SAP
abbrlink: 9f1e6853
date: 2022-05-05 11:38:23
keywords:
---


[ cf-us30-ica-iat ](https://github.tools.sap/CPICACF/cf-us30-ica-iat/)

[ BTP Link ](https://cockpit.canary.scp.sapns2.us/cockpit/#/globalaccount/f573e8a6-301b-4e75-aa26-9e8e805353a4/subaccount)

[ INFRA process ](https://pages.github.tools.sap/IO-CLOUD/ica-docs/development/ica/custom-domain/)

[ NS2 authoring app ](https://icaauthor-ns2.cfapps.canary.scp.sapns2.us/shell/ica.authoring)  [ eu10 ](https://icaauthor-iacd.cfapps.eu10.hana.ondemand.com/shell/ica.authoring)

[ local destop to pull Pro ](https://pages.github.tools.sap/IO-CLOUD-REL-ENG/dev-guide/getting_started/getting_access/)

[ ia-ts-contents ](https://github.tools.sap/IO-CLOUD/ia-ts-contents)

[ Scrum course ](https://pages.github.tools.sap/agile/scrum-course/course-description.html)

[ Iacbox - A Self-Contained DevOps Environment ](https://github.tools.sap/cloudfoundry/iacbox)

[ landscape ](https://github.tools.sap/CPICACF)

[ repo -- clientNode ](https://common.repositories.cloud.sap/ui/native/build.milestones/com/sap/it/spc/icaclientnode/)

> `githubToken` 
`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`

> `JFrogToken`
`AKCp8mYoWpf7cpTkXiyXuHq6TFxVng1HnkAukttfSWPjpZ63GnRduzP6jSRL9XLUfu1VHa4r8`

TypeSystemId + VersionId + Revision ==> Primary key

🆔： I568938

docker login iacbox.common.cdn.repositories.cloud.sap -u "i568938" -p "AKCp8mYoWpf7cpTkXiyXuHq6TFxVng1HnkAukttfSWPjpZ63GnRduzP6jSRL9XLUfu1VHa4r8"


> devOps Env 

[ wiki ](https://github.tools.sap/cloudfoundry/iacbox)

```shell

git clone --recursive https://github.tools.sap/CPICACF/cf-us30-ica-iat

iacbox -iv=iacbox.common.cdn.repositories.cloud.sap/iacbox2:v530

iac state pull

lscrypt unseal

Master-Password:  2020IntegrationAdvisorHeidelberg!

iac init-config -p product-cf-ica --secure-data -d env_setup -f    (subscribe)

iac action create_manifest -d icaautoimport   (ctx.yml file)

iac action deploy -d icaautoimport


#####################################################################

# common  

iac init-config -p product-cf-ica --secure-data -d env_setup -f  #初始化一个component 

iac action deploy -d env_setup

iac -d icaworkspacenode lifecycle deploy --skip-state-update #一个完整的命令，包含所有的步骤

curl 'http://localhost:8080/api/v1/cli?arch=amd64&platform=linux' -o fly && chmod +x ./fly && mv ./fly /usr/local/bin/

sudo ln -s /usr/local/bin/fly /usr/bin/fly

iacbox -iv=iacbox.common.cdn.repositories.cloud.sap/iacbox2:v391

# because creadentials file can is not visible , we must use this script 
lscrypt edit -d ianode credentials.yml 

lscrypt read -d icaworkspacenode credentials.yml

#####################################################################
# two procedure : iac push and git push
# push code to cf-us30
iac state
iac state status
# push to state branch
iac state push
# the next produre is git push.so ..
#####################################################################

```

credentials:
  api:
    apitoken: Z5R1nVh4Sca0YDNOrdlHE
  cflogin:
    email: SAP_SCP_CF_ICA_SETUP_PROD@SAP.COM
    password: 08IntegrationAdvisorWalldorf!
    user: P2002213338
  nexus:
    basic:
      name: cpiproduser
      password: AKCp8kqCFKc5w75bF2C4Dvfc5qGpicKravMR7dtkv1TyyhQ1xUEZXHWYSHw3my49Wauz7FHMh


[ `SAP PassVault`](https://password.wdf.sap.corp/passvault/index.html)


