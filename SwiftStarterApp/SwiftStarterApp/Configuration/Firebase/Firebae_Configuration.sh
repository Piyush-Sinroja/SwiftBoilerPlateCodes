# Name of the resource
GOOGLESERVICE_INFO_PLIST=GoogleService-Info.plist

# Get references to dev and prod versions of the GoogleService-Info.plist
GOOGLESERVICE_INFO_DEV=${PROJECT_DIR}/${TARGET_NAME}/Configuration/Firebase/Firebase-Plist/Dev/${GOOGLESERVICE_INFO_PLIST}
GOOGLESERVICE_INFO_STAGE=${PROJECT_DIR}/${TARGET_NAME}/Configuration/Firebase/Firebase-Plist/Stage/${GOOGLESERVICE_INFO_PLIST}
GOOGLESERVICE_INFO_PROD=${PROJECT_DIR}/${TARGET_NAME}/Configuration/Firebase/Firebase-Plist/Prod/${GOOGLESERVICE_INFO_PLIST}

# Make sure the stg & prod version of GoogleService-Info.plist exists
echo "Looking for ${GOOGLESERVICE_INFO_PLIST} in ${GOOGLESERVICE_INFO_DEV}"
if [ ! -f $GOOGLESERVICE_INFO_DEV ]
then
    echo "No Development GoogleService-Info.plist found. Please ensure it's in the proper directory."
    exit 1
fi

echo "Looking for ${GOOGLESERVICE_INFO_PLIST} in ${GOOGLESERVICE_INFO_STAGE}"
if [ ! -f $GOOGLESERVICE_INFO_STAGE ]
then
    echo "No Stage GoogleService-Info.plist found. Please ensure it's in the proper directory."
    exit 1
fi

echo "Looking for ${GOOGLESERVICE_INFO_PLIST} in ${GOOGLESERVICE_INFO_PROD}"
if [ ! -f $GOOGLESERVICE_INFO_PROD ]
then
    echo "No Production GoogleService-Info.plist found. Please ensure it's in the proper directory."
    exit 1
fi

# Get a reference to the destination location for the GoogleService-Info.plist
PLIST_DESTINATION=${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app
echo "Will copy ${GOOGLESERVICE_INFO_PLIST} to final destination: ${PLIST_DESTINATION}"


# Copy over the stg GoogleService-Info.plist for Debug builds
if [ "${CONFIGURATION}" == "DevDebug" ] || [ "${CONFIGURATION}" == "DevRelease" ]
then
    echo "-> Using ${GOOGLESERVICE_INFO_DEV}"
    echo "-> Config ${CONFIGURATION}"
    cp "${GOOGLESERVICE_INFO_DEV}" "${PLIST_DESTINATION}"
elif [ "${CONFIGURATION}" == "StageDebug" ] || [ "${CONFIGURATION}" == "StageRelease" ]
then
    echo "-> Using ${GOOGLESERVICE_INFO_STAGE}"
    echo "-> Config ${CONFIGURATION}"
    cp "${GOOGLESERVICE_INFO_STAGE}" "${PLIST_DESTINATION}"
elif [ "${CONFIGURATION}" == "ProdDebug" ] || [ "${CONFIGURATION}" == "ProdRelease" ]
then
    echo "-> Using ${GOOGLESERVICE_INFO_PROD}"
    echo "-> Config ${CONFIGURATION}"
    cp "${GOOGLESERVICE_INFO_PROD}" "${PLIST_DESTINATION}"
else
    echo "No Configuration Found!"
fi
