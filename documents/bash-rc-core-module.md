# Bash-rc Core Module

This document focuses on `modules/bash-rc.bashrc` and how it manages the locally-installed repository.

## Purpose

`bash-rc` is the primary command for this project. It handles the testing, publishing, building, and repository formatting of the projects.

## Command Map

<table>
	<thead>
	<tr>
		<th>Operation</th>
		<th>Command</th>
		<th>What it Does</th>
	</tr>
	</thead>
	<tbody>
	<tr>
		<td>Build</td>
		<td><code>bash-rc-build</code></td>
		<td>Updates <code>~/.bashrc</code> based on changes made to <code>base.bash</code></td>
	</tr>
	<tr>
		<td>Update</td>
		<td><code>bash-rc update</code></td>
		<td>Forcefully aligns the repository with the origin remote.</td>
	</tr>
	<tr>
		<td>Checkout</td>
		<td><code>bash-rc checkout</code></td>
		<td>Updates and then checks out a different branch.</td>
	</tr>
	<tr>
		<td>Archive</td>
		<td><code>bash-rc archive</code></td>
		<td>Archives <code>~/.bashrc</code> into the repository.</td>
	</tr>
	<tr>
		<td>Purge</td>
		<td><code>bash-rc purge</code></td>
		<td>Removes archived files in <code>archive/</code>.</td>
	</tr>
	<tr>
		<td>Test</td>
		<td><code>bash rc-test</code></td>
		<td>Starts a shell using test profile behaviour.</td>
	</tr>
	<tr>
		<td>Publish</td>
		<td><code>bash rc-publish</code></td>
		<td>Puts files from <code>test/</code> into modules/profiles/entry scripts.</td>
	</tr>
	<tr>
		<td>Set Path</td>
		<td><code>bash-rc set-path</code></td>
		<td>Updates the <code>BASHRC_PATH</code> and reconfigures the shell to work with the new path.</td>
	</tr>
	</tbody>
</table>

## Interaction With Other Components

<table>
	<thead>
	<tr>
		<th>Component</th>
		<th>Interaction</th>
	</tr>
	</thead>
	<tbody>
	<tr>
		<td><code>base.bash</code></td>
		<td>Source template for publishing to <code>~/.bashrc</code>.</td>
	</tr>
	<tr>
		<td><code>enter.bash</code> / <code>exit.bash</code></td>
		<td>Included indirectly via <code>base.bash</code> in build output.</td>
	</tr>
	<tr>
		<td><code>test/</code></td>
		<td>Used to test new functions or code in a seperate environment.</td>
	</tr>
	<tr>
		<td><code>modules/</code></td>
		<td>All modules to be loaded into the shell environment.</td>
	</tr>
	<tr>
		<td><code>profiles/</code></td>
		<td>Specific hostname-related functionality.</td>
	</tr>
	<tr>
		<td><code>archive/</code></td>
		<td>Stores historical <code>.bashrc</code> snapshots.</td>
	</tr>
	</tbody>
</table>

## Operational Notes

- Build defaults to archiving current `.bashrc` unless `-f` is passed.
- `-k` appends a one-way diff from previous `.bashrc` into new file.
- `-p` and `-c <branch>` call git during building.

