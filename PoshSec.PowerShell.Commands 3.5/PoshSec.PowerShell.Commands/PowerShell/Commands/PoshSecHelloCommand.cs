// <copyright file="PoshSecHelloCommand.cs" company="PoshSec (https://github.com/PoshSec/)">
//     Copyright © 2013 and distributed under the BSD license.
// </copyright>

namespace PoshSec.PowerShell.Commands
{
    using System;
    using System.Management.Automation;
    using Microsoft.PowerShell.Commands;

    /// <summary>
    /// Sample Hello World cmdlet.
    /// </summary>
    [System.Management.Automation.Cmdlet(
        System.Management.Automation.VerbsCommon.Get,
        PoshSec.PowerShell.Nouns.PoshSecHello)]
    public class PoshSecHelloCommand : System.Management.Automation.PSCmdlet
    {
        /// <summary>
        /// Gets or sets the person's name.
        /// </summary>
        [Parameter(Position = 0, Mandatory = true)]
        //public string Name { get; set; }
        public string Name;

        /// <summary>
        /// Provides a record-by-record processing functionality for the cmdlet.
        /// </summary>
        protected override void ProcessRecord()
        {
            string result = string.Format("Hello world. Hello {0}.", this.Name);
            this.WriteObject(result);
        }
    }
}
