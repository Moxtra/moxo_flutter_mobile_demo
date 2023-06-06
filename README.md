![moxo](https://assets-global.website-files.com/612ecbcc615e87b0b9b38524/62037243f5ede375a8705a34_Moxo-Website-Button.svg)

[ [Introduce](#introduce) &bull; [How to run](#how-to-run)]

## Introduce

A flutter demo app based on [flutter_plugin_mep](https://github.com/Moxtra/flutter_plugin_mep)

### Requirement

* iOS 13.0+
* Android 4.4+

## How to run

1. Clone this repo or download zip file, go to root directory of the project.
   Run below command to get dependencies:

```
flutter pub get
```

2. Add Moxo environment details to .env file in root directory of the project. For example:
```
DOMAIN=moxo.moxo.com
CLIENT_ID=YOUR_CLIENT_ID
CLIENT_SECRET=YOUR_CLIENT_SECRET
ORG_ID=YOUR_ORG_ID
EMAIL=YOUR_EMAIL
#UNIQUE_ID=YOUR_UNIQUE_ID 
```
DOMAIN, CLIENT_ID, CLIENT_SECRET, ORG_ID are required. Choose one of UNIQUE_ID and EMAIL as user identity.
By default, this project is using EMAIL. If you prefer UNIQUE_ID, please assign a value and uncomment UNIQUE_ID.


3. When dependencies are ready, run below command to run app:

```
flutter run
```
