// <copyright file="PGetDateISO8601.cs" company="PoshSec (https://github.com/PoshSec/)">
//     Copyright © 2015 and distributed under the 3-clause BSD license.
// </copyright>

namespace PoshSec.PowerShell.Commands
{
    using System;
    using System.Management.Automation;

    /// <summary>
    /// Get a string with a prefix, the current date/time in ISO 8601 format, and a suffix.
    /// ISO 8601 Data elements and interchange formats – Information interchange – Representation of dates and time
    /// </summary>
    [Cmdlet(
        VerbsCommon.Get,
        Nouns.DateISO8601)]
    public class GetDateISO8601 : PSCmdlet
    {
        /// <summary>
        /// Gets or sets a value indicating the beginning of the string.
        /// </summary>
        [Parameter(Mandatory = true)]
        public string Prefix { get; set; }

        /// <summary>
        /// Gets or sets a value indicating the ending of the string.
        /// </summary>
        [Parameter(Mandatory = true)]
        public string Suffix { get; set; }

        /// <summary>
        /// Gets or sets the value indicating whether to include seconds.
        /// </summary>
        [Parameter(Mandatory = false)]
        public SwitchParameter Seconds { get; set; }

        /// <summary>
        /// Gets or sets the value indicating whether to include milliseconds.
        /// </summary>
        [Parameter(Mandatory = false)]
        public SwitchParameter Milliseconds { get; set; }

        /// <summary>
        /// Provides a record-by-record processing functionality for the cmdlet.
        /// </summary>
        protected override void ProcessRecord()
        {
            DateTime now = DateTime.Now;

            string year = now.Year.ToString("0000");
            string month = now.Month.ToString("00");
            string day = now.Day.ToString("00");
            string hour = now.Hour.ToString("00");
            string minute = now.Minute.ToString("00");
            string second = now.Second.ToString("00");
            string millisecond = now.Millisecond.ToString("000");

            string result = string.Format("{0}-{1}-{2}-{3}-{4}-{5}", Prefix, year, month, day, hour, minute);

            if (Seconds)
            {
                result = string.Concat(result, "-", second);
                if (Milliseconds) result = string.Concat(result, "-", millisecond);
            }

            result = string.Concat(result, Suffix);
            WriteObject(result);
        }
    }
}
