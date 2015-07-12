// <copyright file="PoshSecHelloCommand.cs" company="PoshSec (https://github.com/PoshSec/)">
//     Copyright © 2015 and distributed under the 3-clause BSD license.
// </copyright>

namespace PoshSec.PowerShell.Commands
{
    using System.Management.Automation;

    /// <summary>
    /// Sample Hello World cmdlet.
    /// </summary>
    [Cmdlet(
        VerbsCommon.Get,
        Nouns.PoshSecHello)]
    public class PoshSecHelloCommand : PSCmdlet
    {
        /// <summary>
        /// Gets or sets the person's name.
        /// </summary>
        [Parameter(Position = 0, Mandatory = true)]
        public string Name { get; set; }

        /// <summary>
        /// Provides a record-by-record processing functionality for the cmdlet.
        /// </summary>
        protected override void ProcessRecord()
        {
            string result = string.Format("Hello {0}. Thank you for installing PoshSec. You can find more information at www.poshsec.com or https://github.com/poshsec", Name);
            WriteObject(result);
        }
    }
}
