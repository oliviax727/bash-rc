# `.bashrc` Modules

This document covers all `modules/*.bashrc` files and all functions defined in those files.

## Function Inventory

<table>
	<thead>
		<tr>
			<th>Module</th>
			<th>Function</th>
			<th>Description</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>Admiral</td>
			<td><code>admiral</code></td>
			<td>Mimics OpenSSH but for logging into different linux distros on the same local device.</td>
		</tr>
		<tr>
			<td>Bash-rc</td>
			<td><code>bash-rc</code></td>
			<td>Main repository manipulation function.</td>
		</tr>
		<tr>
			<td rowspan="3">C++ Modules</code></td>
			<td><code>init-cpp</code></td>
			<td>Creates a new simple C++ prokect.</td>
		</tr>
		<tr>
			<td><code>run-cpp</code></td>
			<td>Builds and executes a <code>C++</code> file.</td>
		</tr>
		<tr>
			<td><code>debug-cpp</code></td>
			<td>Debugs C++ and opens <code>gdb</code>.</td>
		</tr>
		<tr>
			<td>Git Helpers</td>
			<td><code>git-propagate</code></td>
			<td>Cherry-picks the latest commit across remote branches and pushes.</td>
		</tr>
		<tr>
			<td rowspan="5">Path Manager</td>
			<td><code>test-cmd</code></td>
			<td>Tests if a command works</td>
		</tr>
		<tr>
			<td><code>evalpath</code></td>
			<td>Evaluates a string path and prepares it before giving it to <code>realpath</code>.</td>
		</tr>
		<tr>
			<td><code>set_CWD</code></td>
			<td>Sets additonal environment values that compress common-use paths.</td>
		</tr>
		<tr>
			<td><code>terminal_colour</code></td>
			<td>Sets prompt style/colour themes.</td>
		</tr>
		<tr>
			<td><code>cleanpath</code></td>
			<td>Removes bad or duplicate entries from a path environment variable.</td>
		</tr>
		<tr>
			<td>Python</td>
			<td colspan="2">No project-defined shell functions (so far).</td>
		</tr>
		<tr>
			<td rowspan="3">Quick SSH (QSSH)</td>
			<td><code>sshcd</code></td>
			<td>SSH into a host and then cd into a path.</td>
		</tr>
		<tr>
			<td><code>qssh</code></td>
			<td>Primary function to handle connecting to, copying files to/from, and moving around SSH hosts.</td>
		</tr>
		<tr>
			<td><code>qsc</code></td>
			<td>An alias that quick-connects to a predefined QSSH Host.</td>
		</tr>
	</tbody>
</table>

## Notes

- Several command suites are nested inside dispatcher functions (`admiral`, `bash-rc`, and `qssh`).
- Runtime or system-touching commands (`mount`/`chroot`/`ssh`/network/`git push`) should be treated as integration behaviour during tests.
