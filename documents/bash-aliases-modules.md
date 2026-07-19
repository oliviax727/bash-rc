# Bash Alias Modules

This document covers all `modules/*.bash_aliases` files and every function defined in those files.

It is recommended that you read the script file itself as most aliased are very self-explanatory.

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
			<td rowspan="4">
				Bash Doc Aliases
			</td>
			<td>
				<code>setenv</code>
			</td>
			<td>
				Exports a variable in <code>name=value</code> form.
			</td>
		</tr>
		<tr>
			<td>
				<code>add-alias</code>
			</td>
			<td>
				Adds an alias both to current shell and <code>~/.bash_aliases</code>.
			</td>
		</tr>
		<tr>
			<td>
				<code>repeat</code>
			</td>
			<td>
				Runs a command the requested number of times.
			</td>
		</tr>
		<tr>
			<td>
				<code>_seq</code>
			</td>
			<td>
				Internal integer sequence helper used by <code>repeat</code>.
			</td>
		</tr>
		<tr>
			<td rowspan="3">
				Custom Aliases
			</td>
			<td>
				<code>diff-diode</code>
			</td>
			<td>
				Prints lines present only in the left input file (one-way diff).
			</td>
		</tr>
		<tr>
			<td>
				<code>cd-run</code>
			</td>
			<td>
				Temporarily changes directory, runs a command, then restores the previous
				directory.
			</td>
		</tr>
		<tr>
			<td>
				<code>clean-snaps</code>
			</td>
			<td>
				Removes disabled snap revisions parsed from <code>snap list --all</code>.
			</td>
		</tr>
		<tr>
			<td>
				Default Aliases
			</td>
			<td colspan="2">
				No shell functions are defined.
			</td>
		</tr>
		<tr>
			<td>
				Path Aliases
			</td>
			<td colspan="2">
				No shell functions are defined.
			</td>
		</tr>
	</tbody>
</table>

## Notes

- `modules/default.bash_aliases` exits early for non-interactive shells.
- Multiple aliases with overlapping names can be overridden by load order in `base.bash`.
