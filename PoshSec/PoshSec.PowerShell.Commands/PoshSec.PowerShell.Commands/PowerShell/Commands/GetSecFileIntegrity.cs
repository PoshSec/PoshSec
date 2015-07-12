// <copyright file="GetPoshFileIntegrity.cs" company="PoshSec (https://github.com/PoshSec/)">
//     Copyright © 2015 and distributed under the 3-clause BSD license.
// </copyright>

using PoshSec.Properties;

namespace PoshSec.PowerShell.Commands
{
    using System;
    using System.IO;
    using System.Security.Cryptography;
    using Microsoft.Win32;
    using System.Management.Automation;

    /// <summary>
    /// Get a string with a prefix, the current date/time in ISO 8601 format, and a suffix.
    /// ISO 8601 Data elements and interchange formats – Information interchange – Representation of dates and time
    /// </summary>
    [Cmdlet(
        VerbsCommon.Get,
        Nouns.SecFileIntegrity)]
    public class GetSecFileIntegrity : PSCmdlet
    {
        /// <summary>
        /// Provides a record-by-record processing functionality for the cmdlet.
        /// </summary>
        protected override void ProcessRecord()
        {
            const string registryKeyName = @"SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths";            
            RegistryKey baseKey = RegistryKey.OpenBaseKey(RegistryHive.LocalMachine, RegistryView.Default);
            RegistryKey subKey = baseKey.OpenSubKey(registryKeyName);

            SHA1 sha = new SHA1CryptoServiceProvider();

            if (subKey != null)
                foreach (string app in subKey.GetSubKeyNames())
                {
                    var fileIntegrity = new PoshSecFileIntegrity();

                    RegistryKey fileKey = subKey.OpenSubKey(app);
                    if (fileKey != null)
                    {
                        fileIntegrity.RegistryPath = fileKey.Name;

                        // Enumerate the value names, find the default (string.Empty), get the path, and exit
                        foreach (string name in fileKey.GetValueNames())
                        {
                            if (name == string.Empty)
                            {
                                string value = fileKey.GetValue(name).ToString();
                                value = value.Trim();
                                value = value.Trim('"');
                                value = value.Trim();
                        
                                fileIntegrity.FilePath = value;
                                fileIntegrity.Exists = File.Exists(fileIntegrity.FilePath);
                                break;
                            }
                        }
                    }

                    // If the file exists, read the bytes and get the hash
                    if (fileIntegrity.Exists)
                    {
                        var fileStream = new BinaryReader(File.Open(fileIntegrity.FilePath, FileMode.Open, FileAccess.Read, FileShare.ReadWrite));
                        byte[] fileBytes = fileStream.ReadBytes((int)fileStream.BaseStream.Length);
                        byte[] fileHash = sha.ComputeHash(fileBytes);
                        fileIntegrity.Sha1Hash = Convert.ToBase64String(fileHash);
                    }
            
                    // Send the file integrity object onto the pipeline. For baselining, consume with Export-Clixml.
                    WriteObject(fileIntegrity);
                }
        }

        /// <summary>
        /// PowerShell Security project File Integrity checker.
        /// </summary>
        private class PoshSecFileIntegrity
        {
            /// <summary>
            /// Initializes a new instance of the <see cref="PoshSecFileIntegrity"/> class.
            /// </summary>
            public PoshSecFileIntegrity()
            {
                Exists = false;
                FilePath = string.Empty;
                RegistryPath = string.Empty;
                Sha1Hash = string.Empty;
            }

            /// <summary>
            /// Gets or sets a value indicating whether the file exists on the file system.
            /// </summary>
            public bool Exists { get; set; }

            /// <summary>
            /// Gets or sets a value indicating the file system path.
            /// </summary>
            public string FilePath { get; set; }

            /// <summary>
            /// Gets or sets a value indicating the registry path.
            /// </summary>
            public string RegistryPath { [UsedImplicitly] private get; set; }

            /// <summary>
            /// Gets or sets a value containing the SHA hash in Base64 encoding.
            /// </summary>
            public string Sha1Hash { [UsedImplicitly] private get; set; }
        }
    }
}
