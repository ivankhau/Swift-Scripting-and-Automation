
import radarclient
import sys
import os
from radarclient import RadarClient
from Carbon import Folder, Folders
import datetime


CLIENT_SYSTEM_NAME = 'IvanBot'
CLIENT_SYSTEM_VERSION = '1.0'

input = sys.argv[1]
inputAsInt = int(input)
testRadar = inputAsInt

print testRadar
#testRadar = 40257351 40257291

identifier = radarclient.ClientSystemIdentifier(CLIENT_SYSTEM_NAME, CLIENT_SYSTEM_VERSION)
auth = radarclient.AuthenticationStrategySPNego()
client = radarclient.RadarClient(auth, identifier)

# Get Documents Folder
folderref = Folder.FSFindFolder(Folders.kUserDomain,
    Folders.kDocumentsFolderType, False)
docs = folderref.as_pathname()
print docs

if len(sys.argv) > 2:
    docs = sys.argv[2]

# Get Date As String
now = datetime.datetime.now()
print now
monthFormatted = '%02d' % now.month
dayFormatted = '%02d' % now.day
nowFormatted = str(now.year) + "_" + str(monthFormatted) + "_" + str(dayFormatted)
print nowFormatted

# Directory to Download Everything #
directory = docs + "/" + nowFormatted
print directory

if (os.path.isdir(directory)):
    print 'is directory'
else:
    os.makedirs(directory)
    print 'is not directory, creating directory'



radar = client.radar_for_id(testRadar)
archive_enclosure = radar.attachment_archive_download_enclosure()

## Gets Specific Files Attempt
#attachments = radar.attachments.items()
#for attachment in attachments:
#    print attachment.fileName
#print attachments[4].fileSize
#print attachments[4].fileName


## Check if file is already downloaded, if not download file
fullFileName = directory + "/" + archive_enclosure.fileName
print fullFileName
if not os.path.exists(fullFileName):
    print 'file does not exist, downloading'
    output_path = os.path.join(directory, archive_enclosure.fileName)
    print output_path
    with open(output_path, 'wb') as f:
        archive_enclosure.write_to_file(f)
else:
    print 'file already exists'
