Alphabet Table
==============

Alphabet table will automatically sort your data objects by letter.

http://i.imgur.com/3tMWA.png

To use
-----

Implement the protocol on your data objects:

    @protocol ITVAlphabetObject <NSObject>
    - (NSString*) title;
    @end


Add the data objects to your ITVAlphabetTable instance:

    // ITVAlphabetTable* table = [[ITVAlphabetTable...
    // NSArray* data = [NSArray arrayWithObject:data... all data objects conform to ITVAlphabetObject protocol

    [table addObjectsFromArray:data];
    [table reloadData];


Override your cells to make more interesting cells:

    - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
      static NSString *cellIdentifier = @"VanillaCell";

      NSObject<ITVAlphabetObject>* object = [self objectForIndexPath:indexPath];
   
      UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

      if(cell == nil) {
          cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
      }
      
      [cell.textLabel setText:object.title];
      
      return cell;
    }


