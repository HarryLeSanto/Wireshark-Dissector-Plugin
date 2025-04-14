<h1>Wireshark Dissector Generator</h1>
<h3>Description</h3>
This plugin provides an easy-to-use interface for the creation of simple Wireshark dissectors. By using XML-like tags around example payloads users are able to quickly and easily generate dissectors that are then automatically placed into the plugins folder.
These dissectors are port-based meaning that only one message type can be dissected per port.
<h3>Installation</h3>
Download DissectorGenerator.lua and place it in your Wireshark installation folder. By default this is under %appdata%\Wireshark\plugins.
If you have not installed plugins before you will need to manually create the plugins folder.
<h3>User Guide</h3>
<ol>
<li>Prepare an example payload for the desired packet. To do this in Wireshark:</li>
<ol>
  <li>Select the packet</li>
  <li>Expand the "Data" section</li>
  <li>Right click the "Data" field</li>
  <li>Select Copy > Value</li>
</ol>
<li>In the menu at the top of Wireshark select Tools > Dissector Generator</li>
<li>Fill out the details for the dissector</li>
<ul>
  <li>Name: The name of the dissector</li>
  <li>Protocol: The acronym of the protocol</li>
  <li>Port: The port that the protocol uses</li>
  <li>UDP/TCP: Select whichever the packet is sent with</li>
</ul>
<li>Overwrite the example payload with your prepared payload</li>
<li>Divide your payload into its fields using xml-like tags where the tag is the name of the field</li>
<ul>
<li>Example: &lt;Field1&gt;7686cb4&lt;/Field1&gt;&lt;Field2&gt;a170254f&lt;/Field2&gt;</li>
<li>Each field can be separated by new lines, or the entire payload can be on one line.</li>
<li>Spaces cannot be used in field names.</li>
</ul>
<li>Click "Generate"</li>
<li>Restart Wireshark</li>
